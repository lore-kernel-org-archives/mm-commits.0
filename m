From: akpm@linux-foundation.org
Subject: + procfs-do-not-confuse-jiffies-with-cputime64_t.patch added to -mm tree
Date: Wed, 21 Dec 2011 11:45:07 -0800
Message-ID: <20111221194508.7A22320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49424 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1LUTpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 14:45:12 -0500
Received: by eaak10 with SMTP id k10so15883eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2011 11:45:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwab@linux-m68k.org, adobriyan@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, davej@redhat.com, heiko.carstens@de.ibm.com, mhocko@suse.cz, schwidefsky@de.ibm.com, t.artem@mailcity.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Subject: procfs: do not confuse jiffies with cputime64_t
has been added to the -mm tree.  Its filename is
     procfs-do-not-confuse-jiffies-with-cputime64_t.patch

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

diff -puN arch/ia64/include/asm/cputime.h~procfs-do-not-confuse-jiffies-with-cputime64_t arch/ia64/include/asm/cputime.h
--- a/arch/ia64/include/asm/cputime.h~procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/ia64/include/asm/cputime.h
@@ -60,6 +60,7 @@ typedef u64 cputime64_t;
  */
 #define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
 #define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
+#define usecs_to_cputime64(__usecs)	usecs_to_cputime(__usecs)
 
 /*
  * Convert cputime <-> seconds
diff -puN arch/powerpc/include/asm/cputime.h~procfs-do-not-confuse-jiffies-with-cputime64_t arch/powerpc/include/asm/cputime.h
--- a/arch/powerpc/include/asm/cputime.h~procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/powerpc/include/asm/cputime.h
@@ -150,6 +150,8 @@ static inline cputime_t usecs_to_cputime
 	return ct;
 }
 
+#define usecs_to_cputime64(us)		usecs_to_cputime(us)
+
 /*
  * Convert cputime <-> seconds
  */
diff -puN arch/s390/include/asm/cputime.h~procfs-do-not-confuse-jiffies-with-cputime64_t arch/s390/include/asm/cputime.h
--- a/arch/s390/include/asm/cputime.h~procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/s390/include/asm/cputime.h
@@ -87,6 +87,8 @@ usecs_to_cputime(const unsigned int m)
 	return (cputime_t) m * 4096;
 }
 
+#define usecs_to_cputime64(m)		usecs_to_cputime(m)
+
 /*
  * Convert cputime to milliseconds and back.
  */
diff -puN fs/proc/stat.c~procfs-do-not-confuse-jiffies-with-cputime64_t fs/proc/stat.c
--- a/fs/proc/stat.c~procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/fs/proc/stat.c
@@ -32,7 +32,7 @@ static cputime64_t get_idle_time(int cpu
 		idle = kstat_cpu(cpu).cpustat.idle;
 		idle = cputime64_add(idle, arch_idle_time(cpu));
 	} else
-		idle = nsecs_to_jiffies64(1000 * idle_time);
+		idle = usecs_to_cputime64(idle_time);
 
 	return idle;
 }
@@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int c
 		/* !NO_HZ so we can rely on cpustat.iowait */
 		iowait = kstat_cpu(cpu).cpustat.iowait;
 	else
-		iowait = nsecs_to_jiffies64(1000 * iowait_time);
+		iowait = usecs_to_cputime64(iowait_time);
 
 	return iowait;
 }
diff -puN include/asm-generic/cputime.h~procfs-do-not-confuse-jiffies-with-cputime64_t include/asm-generic/cputime.h
--- a/include/asm-generic/cputime.h~procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/include/asm-generic/cputime.h
@@ -40,6 +40,7 @@ typedef u64 cputime64_t;
  */
 #define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
 #define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
+#define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
 
 /*
  * Convert cputime to seconds and back.
_
Subject: Subject: procfs: do not confuse jiffies with cputime64_t

Patches currently in -mm which might be from schwab@linux-m68k.org are

procfs-do-not-confuse-jiffies-with-cputime64_t.patch
linux-next.patch

