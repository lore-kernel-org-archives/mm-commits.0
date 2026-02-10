Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F392DCC08
	for <mm-commits@vger.kernel.org>; Tue, 10 Feb 2026 15:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738293; cv=none; b=CejjlwtG/+fqyxe0yYTYkPBlVwTfJGonF6LtITRZSIz9gKn7yqPTDIanBHBqcr13h4FpTlZgyZZuLwJhg57p2uvfQ/bOTXn6liIr2/ulJOZG2OnkWlZIejECzknQmTaHXa/hkzrwr9gviCcmbXrgb5Pb1xOF6AVGkzU0pX1/bIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738293; c=relaxed/simple;
	bh=3leU9ZAER5lgexU+SVPw+LLTY2wZk7JCGOyxhN36pvA=;
	h=Date:To:From:Subject:Message-Id; b=Ki3wSOQocSRiUH0coVg3YMDqLRgJBF8jopDeKxP/GBwwvcpWjJTSPZyyyo3yk+IXl5vDF4C4FE1HhxC6h0GZKH7PP0+h89zjOlCedZzuLiJhw44rBUW9vZpHaSH/C0zOINjOzaOV2XBKj8QJCF+JvdFSJqVcJeejbsY6k0wd0c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ggbjL+I3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ggbjL+I3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075CCC116C6;
	Tue, 10 Feb 2026 15:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770738293;
	bh=3leU9ZAER5lgexU+SVPw+LLTY2wZk7JCGOyxhN36pvA=;
	h=Date:To:From:Subject:From;
	b=ggbjL+I3VibdK2exDrJUUTv8UcyMhZy7HtRlXk3pImC4NHFrcTOSZ45jjHXorM2RS
	 JEmImezFLXuYN0d8aRA9O5+I96f2PV3/Ei0xDeaqt8cA6e+vT0Yu0duySTkfAkF1Bq
	 Ct90r2ikcZhTBa5B5S3oTRU19/4hIaQmd4ByL+Qc=
Date: Tue, 10 Feb 2026 07:44:52 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-fix-build-regression-on-accounting-tool.patch added to mm-nonmm-unstable branch
Message-Id: <20260210154453.075CCC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: delayacct: fix build regression on accounting tool
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     delayacct-fix-build-regression-on-accounting-tool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delayacct-fix-build-regression-on-accounting-tool.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: delayacct: fix build regression on accounting tool
Date: Tue, 10 Feb 2026 11:34:22 +0100

The accounting tool was modified for the original ABI using a custom
'timespec64' type in linux/taskstats.h, which I changed to use the regular
__kernel_timespec type, causing a build failure:

        getdelays.c:202:45: warning: 'struct timespec64' declared inside parameter list will not be visible outside of this definition or declaration

     202 | static const char *format_timespec64(struct timespec64 *ts)
         |                                             ^~~~~~~~~~

Change the tool to match the updated header.

Link: https://lkml.kernel.org/r/20260210103427.2984963-1-arnd@kernel.org
Fixes: 503efe850c74 ("delayacct: add timestamp of delay max")
Fixes: f06e31eef4c1 ("delayacct: fix uapi timespec64 definition")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202602091611.lxgINqXp-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/getdelays.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/accounting/getdelays.c~delayacct-fix-build-regression-on-accounting-tool
+++ a/tools/accounting/getdelays.c
@@ -196,20 +196,20 @@ static int get_family_id(int sd)
 #define delay_ms(t) (t / 1000000ULL)
 
 /*
- * Format timespec64 to human readable string (YYYY-MM-DD HH:MM:SS)
+ * Format __kernel_timespec to human readable string (YYYY-MM-DD HH:MM:SS)
  * Returns formatted string or "N/A" if timestamp is zero
  */
-static const char *format_timespec64(struct timespec64 *ts)
+static const char *format_timespec(struct __kernel_timespec *ts)
 {
 	static char buffer[32];
 	struct tm tm_info;
-	time_t time_sec;
+	__kernel_time_t time_sec;
 
 	/* Check if timestamp is zero (not set) */
 	if (ts->tv_sec == 0 && ts->tv_nsec == 0)
 		return "N/A";
 
-	time_sec = (time_t)ts->tv_sec;
+	time_sec = ts->tv_sec;
 
 	/* Use thread-safe localtime_r */
 	if (localtime_r(&time_sec, &tm_info) == NULL)
@@ -257,7 +257,7 @@ static const char *format_timespec64(str
 				average_ms((double)(t)->cpu_delay_total, (t)->cpu_count), \
 				delay_ms((double)(t)->cpu_delay_max), \
 				delay_ms((double)(t)->cpu_delay_min), \
-				format_timespec64(&(t)->cpu_delay_max_ts)); \
+				format_timespec(&(t)->cpu_delay_max_ts)); \
 		} else if (version >= 16) { \
 			printf("%-10s%15s%15s%15s%15s%15s%15s%15s\n", \
 				"CPU", "count", "real total", "virtual total", \
@@ -316,7 +316,7 @@ static const char *format_timespec64(str
 				average_ms((double)(t)->total, (t)->count), \
 				delay_ms((double)(t)->max), \
 				delay_ms((double)(t)->min), \
-				format_timespec64(&(t)->max_ts)); \
+				format_timespec(&(t)->max_ts)); \
 		} else if (version >= 16) { \
 			printf("%-10s%15s%15s%15s%15s%15s\n", \
 				name, "count", "delay total", "delay average", \
_

Patches currently in -mm which might be from arnd@arndb.de are

delayacct-fix-build-regression-on-accounting-tool.patch

