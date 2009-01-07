From: akpm@linux-foundation.org
Subject: - strict_strto-is-not-strict-enough.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:37 -0800
Message-ID: <200901072215.n07MFbMs015382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbZAGWPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, yi.y.yang@intel.com, mm-commits@vger.kernel.org


The patch titled
     strict_strto* is not strict enough
has been removed from the -mm tree.  Its filename was
     strict_strto-is-not-strict-enough.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
lis3lv02d-separate-the-core-from-hp-acpi-api.patch
lis3lv02d-merge-with-leds-hp-disk.patch

