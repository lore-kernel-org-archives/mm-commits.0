From: akpm@linux-foundation.org
Subject: - lzo-add-some-missing-casts.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:14 -0700
Message-ID: <200707312355.l6VNtEJt029215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42826 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762064AbXHAARP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@openedhand.com, edward@namesys.com, rpurdie@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     lzo: add some missing casts
has been removed from the -mm tree.  Its filename was
     lzo-add-some-missing-casts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lzo: add some missing casts
From: Richard Purdie <richard@openedhand.com>

Add some casts to the LZO compression algorithm after they were removed
during cleanup and shouldn't have been.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lzo/lzo1x_compress.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/lzo/lzo1x_compress.c~lzo-add-some-missing-casts lib/lzo/lzo1x_compress.c
--- a/lib/lzo/lzo1x_compress.c~lzo-add-some-missing-casts
+++ a/lib/lzo/lzo1x_compress.c
@@ -32,13 +32,13 @@ _lzo1x_1_do_compress(const unsigned char
 	ip += 4;
 
 	for (;;) {
-		dindex = ((0x21 * DX3(ip, 5, 5, 6)) >> 5) & D_MASK;
+		dindex = ((size_t)(0x21 * DX3(ip, 5, 5, 6)) >> 5) & D_MASK;
 		m_pos = dict[dindex];
 
 		if (m_pos < in)
 			goto literal;
 
-		if (ip == m_pos || (ip - m_pos) > M4_MAX_OFFSET)
+		if (ip == m_pos || ((size_t)(ip - m_pos) > M4_MAX_OFFSET))
 			goto literal;
 
 		m_off = ip - m_pos;
@@ -51,7 +51,7 @@ _lzo1x_1_do_compress(const unsigned char
 		if (m_pos < in)
 			goto literal;
 
-		if (ip == m_pos || (ip - m_pos) > M4_MAX_OFFSET)
+		if (ip == m_pos || ((size_t)(ip - m_pos) > M4_MAX_OFFSET))
 			goto literal;
 
 		m_off = ip - m_pos;
_

Patches currently in -mm which might be from richard@openedhand.com are

origin.patch
git-mtd.patch
