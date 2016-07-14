From: akpm@linux-foundation.org
Subject: [patch 10/20] uapi: export lirc.h header
Date: Thu, 14 Jul 2016 12:07:15 -0700
Message-ID: <5787e2e3.pK8OAUVc9pPaxlE4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcGNTHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mchehab@s-opensource.com, leamas.alec@gmail.com, stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: uapi: export lirc.h header

This header contains the userspace API for lirc.

This is a fixup for b7be755733dc44c72 ("[media] bz#75751: Move internal
header file lirc.h to uapi/").  It moved the header to the right place,
but it forgot to add it at Kbuild.  So, despite being at uapi, it is not
copied to the right place.

Fixes: b7be755733dc44c72 ("[media] bz#75751: Move internal header file lirc.h to uapi/")
Link: http://lkml.kernel.org/r/320c765d32bfc82c582e336d52ffe1026c73c644.1468439021.git.mchehab@s-opensource.com
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Alec Leamas <leamas.alec@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/uapi/linux/Kbuild~uapi-export-lirch-header include/uapi/linux/Kbuild
--- a/include/uapi/linux/Kbuild~uapi-export-lirch-header
+++ a/include/uapi/linux/Kbuild
@@ -245,6 +245,7 @@ endif
 header-y += hw_breakpoint.h
 header-y += l2tp.h
 header-y += libc-compat.h
+header-y += lirc.h
 header-y += limits.h
 header-y += llc.h
 header-y += loop.h
_
