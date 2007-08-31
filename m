From: akpm@linux-foundation.org
Subject: + atomic_opstxt-mention-local_t.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:28:15 -0700
Message-ID: <200708311828.l7VISFUo020756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932925AbXHaS2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grundler@parisc-linux.org


The patch titled
     atomic_ops.txt: mention local_t
has been added to the -mm tree.  Its filename is
     atomic_opstxt-mention-local_t.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atomic_ops.txt: mention local_t
From: Grant Grundler <grundler@parisc-linux.org>

local_t is a variant of atomic_t and has related ops to match.
Add reference for local_t documentation to atomic_ops.txt.

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN Documentation/atomic_ops.txt~atomic_opstxt-mention-local_t Documentation/atomic_ops.txt
--- a/Documentation/atomic_ops.txt~atomic_opstxt-mention-local_t
+++ a/Documentation/atomic_ops.txt
@@ -14,6 +14,10 @@ suffice:
 
 	typedef struct { volatile int counter; } atomic_t;
 
+local_t is very similar to atomic_t. If the counter is per CPU and only
+updated by one CPU, local_t is probably more appropriate. Please see
+Documentation/local_ops.txt for the semantics of local_t.
+
 	The first operations to implement for atomic_t's are the
 initializers and plain reads.
 
_

Patches currently in -mm which might be from grundler@parisc-linux.org are

uli526x-add-suspend-and-resume-routines.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
atomic_opstxt-mention-local_t.patch
