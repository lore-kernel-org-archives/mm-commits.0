From: akpm@linux-foundation.org
Subject: + create-a-div_round_closest-macro-to-do-division-with-rounding.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:36:35 -0800
Message-ID: <200811130036.mAD0aZ20024557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbYKMAhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:37:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com


The patch titled
     Create a DIV_ROUND_CLOSEST macro to do division with rounding
has been added to the -mm tree.  Its filename is
     create-a-div_round_closest-macro-to-do-division-with-rounding.patch

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
Subject: Create a DIV_ROUND_CLOSEST macro to do division with rounding
From: "Darrick J. Wong" <djwong@us.ibm.com>

Create a helper macro to divide two numbers and round the result to the
nearest whole number.  This is a helper macro for hwmon drivers that want
to convert incoming sysfs values per standard hwmon practice, though the
macro itself can be used by anyone.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/kernel.h~create-a-div_round_closest-macro-to-do-division-with-rounding include/linux/kernel.h
--- a/include/linux/kernel.h~create-a-div_round_closest-macro-to-do-division-with-rounding
+++ a/include/linux/kernel.h
@@ -48,6 +48,12 @@ extern const char linux_proc_banner[];
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+#define DIV_ROUND_CLOSEST(x, divisor)(			\
+{							\
+	typeof(divisor) __divisor = divisor;		\
+	(((x) + ((__divisor) / 2)) / (__divisor));	\
+}							\
+)
 
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
_

Patches currently in -mm which might be from djwong@us.ibm.com are

fix-platform-drivers-that-crash-on-suspend-resume.patch
i5000-edac-hold-reference-to-mci-kobject.patch
adt7470-check-input-range-when-sysfs-files-are-written.patch
adt7473-check-inputs-from-sysfs-writes.patch
lm85-support-adt7468-chips.patch
adt7462-new-hwmon-driver.patch
ics932s401-new-driver.patch
linux-next.patch
create-a-div_round_closest-macro-to-do-division-with-rounding.patch
adt7462-70-73-use-div_round_closest-for-rounded-division.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch

