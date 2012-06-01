From: akpm@linux-foundation.org
Subject: [merged] codingstyle-add-kmalloc_array-to-memory-allocators.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:32:47 -0700
Message-ID: <20120601193247.6AB7EA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:56279 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757777Ab2FATct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:32:49 -0400
Received: by lagr15 with SMTP id r15so139243lag.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:32:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xi.wang@gmail.com, jj@chaosbits.net, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: CodingStyle: add kmalloc_array() to memory allocators
has been removed from the -mm tree.  Its filename was
     codingstyle-add-kmalloc_array-to-memory-allocators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: CodingStyle: add kmalloc_array() to memory allocators

Add the new kmalloc_array() to the list of general-purpose memory
allocators in chapter 14.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Acked-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN Documentation/CodingStyle~codingstyle-add-kmalloc_array-to-memory-allocators Documentation/CodingStyle
--- a/Documentation/CodingStyle~codingstyle-add-kmalloc_array-to-memory-allocators
+++ a/Documentation/CodingStyle
@@ -671,8 +671,9 @@ ones already enabled by DEBUG.
 		Chapter 14: Allocating memory
 
 The kernel provides the following general purpose memory allocators:
-kmalloc(), kzalloc(), kcalloc(), vmalloc(), and vzalloc().  Please refer to
-the API documentation for further information about them.
+kmalloc(), kzalloc(), kmalloc_array(), kcalloc(), vmalloc(), and
+vzalloc().  Please refer to the API documentation for further information
+about them.
 
 The preferred form for passing a size of a struct is the following:
 
@@ -686,6 +687,17 @@ Casting the return value which is a void
 from void pointer to any other pointer type is guaranteed by the C programming
 language.
 
+The preferred form for allocating an array is the following:
+
+	p = kmalloc_array(n, sizeof(...), ...);
+
+The preferred form for allocating a zeroed array is the following:
+
+	p = kcalloc(n, sizeof(...), ...);
+
+Both forms check for overflow on the allocation size n * sizeof(...),
+and return NULL if that occurred.
+
 
 		Chapter 15: The inline disease
 
_

Patches currently in -mm which might be from xi.wang@gmail.com are

origin.patch
linux-next.patch
introduce-size_max.patch

