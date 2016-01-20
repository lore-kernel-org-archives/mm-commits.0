From: akpm@linux-foundation.org
Subject: [folded-merged]
 ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch removed from
 -mm tree
Date: Wed, 20 Jan 2016 14:36:10 -0800
Message-ID: <56a00bda.0IBTLyFCvV5s4Ypp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbcATWgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:36:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-3
has been removed from the -mm tree.  Its filename was
     ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch

This patch was dropped because it was folded into ubsan-run-time-undefined-behavior-sanity-checker.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-3

fix __int128 build woes

Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    2 +-
 lib/ubsan.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix-3 lib/ubsan.c
--- a/lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix-3
+++ a/lib/ubsan.c
@@ -120,7 +120,7 @@ static void val_to_string(char *str, siz
 {
 	if (type_is_int(type)) {
 		if (type_bit_width(type) == 128) {
-#ifdef CONFIG_ARCH_SUPPORTS_INT128
+#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
 			u_max val = get_unsigned_val(type, value);
 
 			scnprintf(str, size, "0x%08x%08x%08x%08x",
diff -puN lib/ubsan.h~ubsan-run-time-undefined-behavior-sanity-checker-fix-3 lib/ubsan.h
--- a/lib/ubsan.h~ubsan-run-time-undefined-behavior-sanity-checker-fix-3
+++ a/lib/ubsan.h
@@ -73,7 +73,7 @@ struct invalid_value_data {
 	struct type_descriptor *type;
 };
 
-#ifdef CONFIG_ARCH_SUPPORTS_INT128
+#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
 typedef __int128 s_max;
 typedef unsigned __int128 u_max;
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ubsan-run-time-undefined-behavior-sanity-checker.patch
fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch

