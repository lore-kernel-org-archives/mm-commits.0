From: akpm@linux-foundation.org
Subject: + mutex-prevent-optimistic-spinning-from-spinning-longer-than-neccessary.patch added to -mm tree
Date: Thu, 19 Aug 2010 14:42:10 -0700
Message-ID: <201008192142.o7JLgAJg010043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059Ab0HSVmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 17:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.c.chen@linux.intel.com


The patch titled
     mutex: prevent optimistic spinning from spinning longer than necce=
ssary
has been added to the -mm tree.  Its filename is
     mutex-prevent-optimistic-spinning-from-spinning-longer-than-necces=
sary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mutex: prevent optimistic spinning from spinning longer than n=
eccessary
=46rom: Tim Chen <tim.c.chen@linux.intel.com>

There is a scalability issue for current implementation of optimistic
mutex spin in the kernel.  It is found on a 8 node 64 core Nehalem-EX
system (HT mode).

The intention of the optimistic mutex spin is to busy wait and spin on =
a
mutex if the owner of the mutex is running, in the hope that the mutex
will be released soon and be acquired, without the thread trying to
acquire mutex going to sleep.  However, when we have a large number of
threads, contending for the mutex, we could have the mutex grabbed by
other thread, and then another =E2=80=A6=E2=80=A6, and we will keep spi=
nning, wasting
cpu cycles and adding to the contention.  One possible fix is to quit
spinning and put the current thread on wait-list if mutex lock switch t=
o a
new owner while we spin, indicating heavy contention (see the patch
included).

I did some testing on a 8 socket Nehalem-EX system with a total of 64
cores.  Using Ingo's test-mutex program that creates/delete files with =
256
threads (http://lkml.org/lkml/2006/1/8/50) , I see the following speed =
up
after putting in the mutex spin fix:

=2E/mutex-test V 256 10
                Ops/sec
2.6.34          62864
With fix        197200

Repeating the test with Aim7 fserver workload, again there is a speed u=
p
with the fix:

                Jobs/min
2.6.34          91657
With fix        149325

To look at the impact on the distribution of mutex acquisition time, I
collected the mutex acquisition time on Aim7 fserver workload with some
instrumentation.  The average acquisition time is reduced by 48% and
number of contentions reduced by 32%.

                #contentions    Time to acquire mutex (cycles)
2.6.34          72973           44765791
With fix        49210           23067129

The histogram of mutex acquisition time is listed below.  The acquisiti=
on
time is in 2^bin cycles.  We see that without the fix, the acquisition
time is mostly around 2^26 cycles.  With the fix, we the distribution g=
et
spread out a lot more towards the lower cycles, starting from 2^13.=20
However, there is an increase of the tail distribution with the fix at
2^28 and 2^29 cycles.  It seems a small price to pay for the reduced
average acquisition time and also getting the cpu to do useful work.

Mutex acquisition time distribution (acq time =3D 2^bin cycles):
        2.6.34                  With Fix
bin     #occurrence     %       #occurrence     %
11      2               0.00%   120             0.24%
12      10              0.01%   790             1.61%
13      14              0.02%   2058            4.18%
14      86              0.12%   3378            6.86%
15      393             0.54%   4831            9.82%
16      710             0.97%   4893            9.94%
17      815             1.12%   4667            9.48%
18      790             1.08%   5147            10.46%
19      580             0.80%   6250            12.70%
20      429             0.59%   6870            13.96%
21      311             0.43%   1809            3.68%
22      255             0.35%   2305            4.68%
23      317             0.44%   916             1.86%
24      610             0.84%   233             0.47%
25      3128            4.29%   95              0.19%
26      63902           87.69%  122             0.25%
27      619             0.85%   286             0.58%
28      0               0.00%   3536            7.19%
29      0               0.00%   903             1.83%
30      0               0.00%   0               0.00%

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/sched.c~mutex-prevent-optimistic-spinning-from-spinnin=
g-longer-than-neccessary kernel/sched.c
--- a/kernel/sched.c~mutex-prevent-optimistic-spinning-from-spinning-lo=
nger-than-neccessary
+++ a/kernel/sched.c
@@ -3865,8 +3865,11 @@ int mutex_spin_on_owner(struct mutex *lo
 		/*
 		 * Owner changed, break to re-assess state.
 		 */
-		if (lock->owner !=3D owner)
+		if (lock->owner !=3D owner) {
+			if (lock->owner)
+				return 0;
 			break;
+		}
=20
 		/*
 		 * Is that owner really running on that cpu?
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com=
 are

origin.patch
mutex-prevent-optimistic-spinning-from-spinning-longer-than-neccessary.=
patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
