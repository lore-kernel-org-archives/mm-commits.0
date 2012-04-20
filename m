From: akpm@linux-foundation.org
Subject: + codingstyle-add-kmalloc_array-to-memory-allocators.patch added to -mm tree
Date: Fri, 20 Apr 2012 15:26:21 -0700
Message-ID: <20120420222621.89346A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:40353 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2DTW0X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 18:26:23 -0400
Received: by wejx9 with SMTP id x9so479715wej.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 15:26:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xi.wang@gmail.com, jj@chaosbits.net, penberg@kernel.org


The patch titled
     Subject: CodingStyle: add kmalloc_array() to memory allocators
has been added to the -mm tree.  Its filename is
     codingstyle-add-kmalloc_array-to-memory-allocators.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: CodingStyle: add kmalloc_array() to memory allocators

Patches currently in -mm which might be from xi.wang@gmail.com are

linux-next.patch
codingstyle-add-kmalloc_array-to-memory-allocators.patch

