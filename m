From: akpm@linux-foundation.org
Subject: + reapply-procfs-do-not-confuse-jiffies-with-cputime64_t.patch added to -mm tree
Date: Wed, 21 Dec 2011 12:01:17 -0800
Message-ID: <20111221200118.3ACD220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:46501 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1LUUBW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 15:01:22 -0500
Received: by faar15 with SMTP id r15so254795faa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2011 12:01:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwab@linux-m68k.org, adobriyan@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, davej@redhat.com, heiko.carstens@de.ibm.com, mhocko@suse.cz, schwidefsky@de.ibm.com, t.artem@mailcity.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Subject: procfs: do not confuse jiffies with cputime64_t
has been added to the -mm tree.  Its filename is
     reapply-procfs-do-not-confuse-jiffies-with-cputime64_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andreas Schwab <schwab@linux-m68k.org>
Subject: procfs: do not confuse jiffies with cputime64_t

get_{idle,iowait}_time are supposed to return cputime64_t values, not
jiffies.  Add usecs_to_cputime64 for this.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Artem S. Tashkinov" <t.artem@mailcity.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/cputime.h    |    1 +
 arch/powerpc/include/asm/cputime.h |    2 ++
 arch/s390/include/asm/cputime.h    |    2 ++
 fs/proc/stat.c                     |    4 ++--
 include/asm-generic/cputime.h      |    1 +
 5 files changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/ia64/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t arch/ia64/include/asm/cputime.h
--- a/arch/ia64/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/ia64/include/asm/cputime.h
@@ -50,6 +50,7 @@ typedef u64 __nocast cputime64_t;
 	((__force u64)(__ct) / NSEC_PER_USEC)
 #define usecs_to_cputime(__usecs)	\
 	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
+#define usecs_to_cputime64(__usecs)	usecs_to_cputime(__usecs)
 
 /*
  * Convert cputime <-> seconds
diff -puN arch/powerpc/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t arch/powerpc/include/asm/cputime.h
--- a/arch/powerpc/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/powerpc/include/asm/cputime.h
@@ -134,6 +134,8 @@ static inline cputime_t usecs_to_cputime
 	return (__force cputime_t) ct;
 }
 
+#define usecs_to_cputime64(us)		usecs_to_cputime(us)
+
 /*
  * Convert cputime <-> seconds
  */
diff -puN arch/s390/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t arch/s390/include/asm/cputime.h
--- a/arch/s390/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/s390/include/asm/cputime.h
@@ -72,6 +72,8 @@ static inline cputime_t usecs_to_cputime
 	return (__force cputime_t)(m * 4096ULL);
 }
 
+#define usecs_to_cputime64(m)		usecs_to_cputime(m)
+
 /*
  * Convert cputime to milliseconds and back.
  */
diff -puN fs/proc/stat.c~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t fs/proc/stat.c
--- a/fs/proc/stat.c~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/fs/proc/stat.c
@@ -31,7 +31,7 @@ static u64 get_idle_time(int cpu)
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
 		idle += arch_idle_time(cpu);
 	} else
-		idle = nsecs_to_jiffies64(1000 * idle_time);
+		idle = usecs_to_cputime64(idle_time);
 
 	return idle;
 }
@@ -44,7 +44,7 @@ static u64 get_iowait_time(int cpu)
 		/* !NO_HZ so we can rely on cpustat.iowait */
 		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	else
-		iowait = nsecs_to_jiffies64(1000 * iowait_time);
+		iowait = usecs_to_cputime64(iowait_time);
 
 	return iowait;
 }
diff -puN include/asm-generic/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t include/asm-generic/cputime.h
--- a/include/asm-generic/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/include/asm-generic/cputime.h
@@ -27,6 +27,7 @@ typedef u64 __nocast cputime64_t;
 	jiffies_to_usecs(cputime_to_jiffies(__ct));
 #define usecs_to_cputime(__msecs)	\
 	jiffies_to_cputime(usecs_to_jiffies(__msecs));
+#define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
 
 /*
  * Convert cputime to seconds and back.
_
Subject: Subject: procfs: do not confuse jiffies with cputime64_t

Patches currently in -mm which might be from schwab@linux-m68k.org are

procfs-do-not-confuse-jiffies-with-cputime64_t.patch
linux-next.patch
reapply-procfs-do-not-confuse-jiffies-with-cputime64_t.patch

