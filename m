From: akpm@linux-foundation.org
Subject: + sysctl-check-for-uint_max-before-unsigned-int-min-max.patch
 added to -mm tree
Date: Mon, 16 Oct 2017 15:06:18 -0700
Message-ID: <59e52d5a.RAFRqgDTtS/z0GBQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37756 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754343AbdJPWGT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 18:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.lawrence@redhat.com, axboe@kernel.dk, mpatocka@redhat.com, mtk.manpages@gmail.com, rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: check for UINT_MAX before unsigned int min/max
has been added to the -mm tree.  Its filename is
     sysctl-check-for-uint_max-before-unsigned-int-min-max.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-check-for-uint_max-before-unsigned-int-min-max.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-check-for-uint_max-before-unsigned-int-min-max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: sysctl: check for UINT_MAX before unsigned int min/max

Mikulas noticed in the existing do_proc_douintvec_minmax_conv() and
do_proc_dopipe_max_size_conv() introduced in this patchset, that they
inconsistently handle overflow and min/max range inputs:

For example:

  0 ... param->min - 1 ---> ERANGE
  param->min ... param->max ---> the value is accepted
  param->max + 1 ... 0x100000000L + param->min - 1 ---> ERANGE
  0x100000000L + param->min ... 0x100000000L + param->max ---> EINVAL
  0x100000000L + param->max + 1, 0x200000000L + param->min - 1 ---> ERANGE
  0x200000000L + param->min ... 0x200000000L + param->max ---> EINVAL
  0x200000000L + param->max + 1, 0x300000000L + param->min - 1 ---> ERANGE

In do_proc_do*() routines which store values into unsigned int variables
(4 bytes wide for 64-bit builds), first validate that the input unsigned
long value (8 bytes wide for 64-bit builds) will fit inside the smaller
unsigned int variable.  Then check that the unsigned int value falls
inside the specified parameter min, max range.  Otherwise the unsigned
long -> unsigned int conversion drops leading bits from the input value,
leading to the inconsistent pattern Mikulas documented above.

Link: http://lkml.kernel.org/r/1507658689-11669-5-git-send-email-joe.lawrence@redhat.com
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN kernel/sysctl.c~sysctl-check-for-uint_max-before-unsigned-int-min-max kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-check-for-uint_max-before-unsigned-int-min-max
+++ a/kernel/sysctl.c
@@ -2572,12 +2572,13 @@ static int do_proc_douintvec_minmax_conv
 	if (write) {
 		unsigned int val = *lvalp;
 
+		if (*lvalp > UINT_MAX)
+			return -EINVAL;
+
 		if ((param->min && *param->min > val) ||
 		    (param->max && *param->max < val))
 			return -ERANGE;
 
-		if (*lvalp > UINT_MAX)
-			return -EINVAL;
 		*valp = val;
 	} else {
 		unsigned int val = *valp;
@@ -2628,17 +2629,18 @@ static int do_proc_dopipe_max_size_conv(
 	struct do_proc_dopipe_max_size_conv_param *param = data;
 
 	if (write) {
-		unsigned int val = round_pipe_size(*lvalp);
+		unsigned int val;
 
+		if (*lvalp > UINT_MAX)
+			return -EINVAL;
+
+		val = round_pipe_size(*lvalp);
 		if (val == 0)
 			return -EINVAL;
 
 		if (param->min && *param->min > val)
 			return -ERANGE;
 
-		if (*lvalp > UINT_MAX)
-			return -EINVAL;
