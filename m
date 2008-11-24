From: akpm@linux-foundation.org
Subject: + strict_strto-is-not-strict-enough.patch added to -mm tree
Date: Mon, 24 Nov 2008 14:19:58 -0800
Message-ID: <200811242219.mAOMJws9021268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbYKXWUE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:20:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, yi.y.yang@intel.com


The patch titled
     strict_strto* is not strict enough
has been added to the -mm tree.  Its filename is
     strict_strto-is-not-strict-enough.patch

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
Subject: strict_strto* is not strict enough
From: Pavel Machek <pavel@suse.cz>

It decodes "\n" as 0, which is bad, because stray echo into backlight
will turn your backlight off, etc...

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Yi Yang <yi.y.yang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/vsprintf.c~strict_strto-is-not-strict-enough lib/vsprintf.c
--- a/lib/vsprintf.c~strict_strto-is-not-strict-enough
+++ a/lib/vsprintf.c
@@ -170,6 +170,8 @@ int strict_strtoul(const char *cp, unsig
 		return -EINVAL;
 
 	val = simple_strtoul(cp, &tail, base);
+	if (tail == cp)
+		return -EINVAL;
 	if ((*tail == '\0') ||
 		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
 		*res = val;
@@ -241,6 +243,8 @@ int strict_strtoull(const char *cp, unsi
 		return -EINVAL;
 
 	val = simple_strtoull(cp, &tail, base);
+	if (tail == cp)
+		return -EINVAL;
 	if ((*tail == '\0') ||
 		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
 		*res = val;
_

Patches currently in -mm which might be from pavel@suse.cz are

linux-next.patch
backlight-catch-invalid-input.patch
backlight-catch-invalid-input-checkpatch-fixes.patch
strict_strto-is-not-strict-enough.patch
lis3lv02d-separate-the-core-from-hp-acpi-api.patch
lis3lv02d-merge-with-leds-hp-disk.patch

