From: akpm@linux-foundation.org
Subject: - atomic_opstxt-mention-local_t.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:27 -0700
Message-ID: <200710180659.l9I6xRDA030985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325AbXJRG7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grundler@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     atomic_ops.txt: mention local_t
has been removed from the -mm tree.  Its filename was
     atomic_opstxt-mention-local_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atomic_ops.txt: mention local_t
From: Grant Grundler <grundler@parisc-linux.org>

local_t is a variant of atomic_t and has related ops to match.
Add reference for local_t documentation to atomic_ops.txt.

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt |    4 ++++
 1 file changed, 4 insertions(+)

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

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
