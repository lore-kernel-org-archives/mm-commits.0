From: akpm@linux-foundation.org
Subject: + documentation-update-ring-buffer-designtxt.patch added to -mm tree
Date: Tue, 22 Dec 2009 14:41:53 -0800
Message-ID: <200912222241.nBMMfrqd028686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbZLVWmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 17:42:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mel@csn.ul.ie, rostedt@goodmis.org


The patch titled
     Documentation: update ring-buffer-design.txt
has been added to the -mm tree.  Its filename is
     documentation-update-ring-buffer-designtxt.patch

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
Subject: Documentation: update ring-buffer-design.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos, grammos, spellos, hyphenation.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/ring-buffer-design.txt |   56 +++++++++----------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff -puN Documentation/trace/ring-buffer-design.txt~documentation-update-ring-buffer-designtxt Documentation/trace/ring-buffer-design.txt
--- a/Documentation/trace/ring-buffer-design.txt~documentation-update-ring-buffer-designtxt
+++ a/Documentation/trace/ring-buffer-design.txt
@@ -33,9 +33,9 @@ head_page - a pointer to the page that t
 
 tail_page - a pointer to the page that will be written to next
 
-commit_page - a pointer to the page with the last finished non nested write.
+commit_page - a pointer to the page with the last finished non-nested write.
 
-cmpxchg - hardware assisted atomic transaction that performs the following:
+cmpxchg - hardware-assisted atomic transaction that performs the following:
 
    A = B iff previous A == C
 
@@ -52,15 +52,15 @@ The Generic Ring Buffer
 The ring buffer can be used in either an overwrite mode or in
 producer/consumer mode.
 
-Producer/consumer mode is where the producer were to fill up the
+Producer/consumer mode is where if the producer were to fill up the
 buffer before the consumer could free up anything, the producer
 will stop writing to the buffer. This will lose most recent events.
 
-Overwrite mode is where the produce were to fill up the buffer
+Overwrite mode is where if the producer were to fill up the buffer
 before the consumer could free up anything, the producer will
 overwrite the older data. This will lose the oldest events.
 
-No two writers can write at the same time (on the same per cpu buffer),
+No two writers can write at the same time (on the same per-cpu buffer),
 but a writer may interrupt another writer, but it must finish writing
 before the previous writer may continue. This is very important to the
 algorithm. The writers act like a "stack". The way interrupts works
@@ -79,16 +79,16 @@ the interrupt doing a write as well.
 
 Readers can happen at any time. But no two readers may run at the
 same time, nor can a reader preempt/interrupt another reader. A reader
-can not preempt/interrupt a writer, but it may read/consume from the
+cannot preempt/interrupt a writer, but it may read/consume from the
 buffer at the same time as a writer is writing, but the reader must be
 on another processor to do so. A reader may read on its own processor
 and can be preempted by a writer.
 
-A writer can preempt a reader, but a reader can not preempt a writer.
+A writer can preempt a reader, but a reader cannot preempt a writer.
 But a reader can read the buffer at the same time (on another processor)
 as a writer.
 
-The ring buffer is made up of a list of pages held together by a link list.
+The ring buffer is made up of a list of pages held together by a linked list.
 
 At initialization a reader page is allocated for the reader that is not
 part of the ring buffer.
@@ -102,7 +102,7 @@ the head page.
 
 The reader has its own page to use. At start up time, this page is
 allocated but is not attached to the list. When the reader wants
-to read from the buffer, if its page is empty (like it is on start up)
+to read from the buffer, if its page is empty (like it is on start-up),
 it will swap its page with the head_page. The old reader page will
 become part of the ring buffer and the head_page will be removed.
 The page after the inserted page (old reader_page) will become the
@@ -206,7 +206,7 @@ The main pointers:
 
   commit page - the page that last finished a write.
 
-The commit page only is updated by the outer most writer in the
+The commit page only is updated by the outermost writer in the
 writer stack. A writer that preempts another writer will not move the
 commit page.
 
@@ -281,7 +281,7 @@ with the previous write.
 The commit pointer points to the last write location that was
 committed without preempting another write. When a write that
 preempted another write is committed, it only becomes a pending commit
-and will not be a full commit till all writes have been committed.
+and will not be a full commit until all writes have been committed.
 
 The commit page points to the page that has the last full commit.
 The tail page points to the page with the last write (before
@@ -292,7 +292,7 @@ be several pages ahead. If the tail page
 page then no more writes may take place (regardless of the mode
 of the ring buffer: overwrite and produce/consumer).
 
-The order of pages are:
+The order of pages is:
 
  head page
  commit page
@@ -311,7 +311,7 @@ Possible scenario:
 There is a special case that the head page is after either the commit page
 and possibly the tail page. That is when the commit (and tail) page has been
 swapped with the reader page. This is because the head page is always
-part of the ring buffer, but the reader page is not. When ever there
+part of the ring buffer, but the reader page is not. Whenever there
 has been less than a full page that has been committed inside the ring buffer,
 and a reader swaps out a page, it will be swapping out the commit page.
 
@@ -338,7 +338,7 @@ and a reader swaps out a page, it will b
 In this case, the head page will not move when the tail and commit
 move back into the ring buffer.
 
-The reader can not swap a page into the ring buffer if the commit page
+The reader cannot swap a page into the ring buffer if the commit page
 is still on that page. If the read meets the last commit (real commit
 not pending or reserved), then there is nothing more to read.
 The buffer is considered empty until another full commit finishes.
@@ -395,7 +395,7 @@ The main idea behind the lockless algori
 of the head_page pointer with the swapping of pages with the reader.
 State flags are placed inside the pointer to the page. To do this,
 each page must be aligned in memory by 4 bytes. This will allow the 2
-least significant bits of the address to be used as flags. Since
+least significant bits of the address to be used as flags, since
 they will always be zero for the address. To get the address,
 simply mask out the flags.
 
@@ -460,7 +460,7 @@ When the reader tries to swap the page w
 will also use cmpxchg. If the flag bit in the pointer to the
 head page does not have the HEADER flag set, the compare will fail
 and the reader will need to look for the new head page and try again.
-Note, the flag UPDATE and HEADER are never set at the same time.
+Note, the flags UPDATE and HEADER are never set at the same time.
 
 The reader swaps the reader page as follows:
 
@@ -539,7 +539,7 @@ updated to the reader page.
     |  +-----------------------------+   |
     +------------------------------------+
 
-Another important point. The page that the reader page points back to
+Another important point: The page that the reader page points back to
 by its previous pointer (the one that now points to the new head page)
 never points back to the reader page. That is because the reader page is
 not part of the ring buffer. Traversing the ring buffer via the next pointers
@@ -572,7 +572,7 @@ not be able to swap the head page from t
 move the head page, until the writer is finished with the move.
 
 This eliminates any races that the reader can have on the writer. The reader
-must spin, and this is why the reader can not preempt the writer.
+must spin, and this is why the reader cannot preempt the writer.
 
             tail page
                |
@@ -659,9 +659,9 @@ before pushing the head page. If it is, 
 tail page wrapped the buffer, and we must drop new writes.
 
 This is not a race condition, because the commit page can only be moved
-by the outter most writer (the writer that was preempted).
+by the outermost writer (the writer that was preempted).
 This means that the commit will not move while a writer is moving the
-tail page. The reader can not swap the reader page if it is also being
+tail page. The reader cannot swap the reader page if it is also being
 used as the commit page. The reader can simply check that the commit
 is off the reader page. Once the commit page leaves the reader page
 it will never go back on it unless a reader does another swap with the
@@ -733,7 +733,7 @@ The write converts the head page pointer
 --->|   |<---|   |<---|   |<---|   |<---
     +---+    +---+    +---+    +---+
 
-But if a nested writer preempts here. It will see that the next
+But if a nested writer preempts here, it will see that the next
 page is a head page, but it is also nested. It will detect that
 it is nested and will save that information. The detection is the
 fact that it sees the UPDATE flag instead of a HEADER or NORMAL
@@ -761,7 +761,7 @@ to NORMAL.
 --->|   |<---|   |<---|   |<---|   |<---
     +---+    +---+    +---+    +---+
 
-After the nested writer finishes, the outer most writer will convert
+After the nested writer finishes, the outermost writer will convert
 the UPDATE pointer to NORMAL.
 
 
@@ -812,7 +812,7 @@ head page.
     +---+    +---+    +---+    +---+
 
 The nested writer moves the tail page forward. But does not set the old
-update page to NORMAL because it is not the outer most writer.
+update page to NORMAL because it is not the outermost writer.
 
                     tail page
                         |
@@ -892,7 +892,7 @@ It will return to the first writer.
 --->|   |<---|   |<---|   |<---|   |<---
     +---+    +---+    +---+    +---+
 
-The first writer can not know atomically test if the tail page moved
+The first writer cannot know atomically if the tail page moved
 while it updates the HEAD page. It will then update the head page to
 what it thinks is the new head page.
 
@@ -923,9 +923,9 @@ if the tail page is either where it use 
 --->|   |<---|   |<---|   |<---|   |<---
     +---+    +---+    +---+    +---+
 
-If tail page != A and tail page does not equal B, then it must reset the
-pointer back to NORMAL. The fact that it only needs to worry about
-nested writers, it only needs to check this after setting the HEAD page.
+If tail page != A and tail page != B, then it must reset the pointer
+back to NORMAL. The fact that it only needs to worry about nested
+writers means that it only needs to check this after setting the HEAD page.
 
 
 (first writer)
@@ -939,7 +939,7 @@ nested writers, it only needs to check t
     +---+    +---+    +---+    +---+
 
 Now the writer can update the head page. This is also why the head page must
-remain in UPDATE and only reset by the outer most writer. This prevents
+remain in UPDATE and only reset by the outermost writer. This prevents
 the reader from seeing the incorrect head page.
 
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
lib-stringc-fix-kernel-doc-warnings.patch
mm-tracing-cleanup-documentation-trace-events-kmemtxt.patch
docs-large-update-to-ioctl-numbertxt.patch
documentation-update-mmiotracetxt.patch
documentation-update-tracepoint-analysistxt.patch
documentation-update-ftrace-designtxt.patch
documentation-update-ring-buffer-designtxt.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

