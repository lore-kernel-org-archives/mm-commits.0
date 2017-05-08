From: akpm@linux-foundation.org
Subject: [patch 089/114] Documentation/vm/transhuge.txt: fix
 trivial typos
Date: Mon, 08 May 2017 15:59:02 -0700
Message-ID: <20170508225902.0yqOW92oI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752940AbdEHW7D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, mm-commits@vger.kernel.org, sj38.park@gmail.com, torvalds@linux-foundation.org

From: SeongJae Park <sj38.park@gmail.com>
Subject: Documentation/vm/transhuge.txt: fix trivial typos

[akpm@linux-foundation.org: fixes per Randy]
Link: http://lkml.kernel.org/r/20170405210259.2067-1-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/vm/transhuge.txt~docs-vm-transhuge-fix-few-trivial-typos Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~docs-vm-transhuge-fix-few-trivial-typos
+++ a/Documentation/vm/transhuge.txt
@@ -266,7 +266,7 @@ for each mapping.
 
 The number of file transparent huge pages mapped to userspace is available
 by reading ShmemPmdMapped and ShmemHugePages fields in /proc/meminfo.
-To identify what applications are mapping file  transparent huge pages, it
+To identify what applications are mapping file transparent huge pages, it
 is necessary to read /proc/PID/smaps and count the FileHugeMapped fields
 for each mapping.
 
@@ -292,7 +292,7 @@ thp_collapse_alloc_failed is incremented
 	the allocation.
 
 thp_file_alloc is incremented every time a file huge page is successfully
-i	allocated.
+	allocated.
 
 thp_file_mapped is incremented every time a file huge page is mapped into
 	user address space.
@@ -501,7 +501,7 @@ scanner can get reference to a page is g
 
 All tail pages have zero ->_refcount until atomic_add(). This prevents the
 scanner from getting a reference to the tail page up to that point. After the
-atomic_add() we don't care about the ->_refcount value.  We already known how
+atomic_add() we don't care about the ->_refcount value. We already known how
 many references should be uncharged from the head page.
 
 For head page get_page_unless_zero() will succeed and we don't mind. It's
@@ -519,8 +519,8 @@ comes. Splitting will free up unused sub
 
 Splitting the page right away is not an option due to locking context in
 the place where we can detect partial unmap. It's also might be
-counterproductive since in many cases partial unmap unmap happens during
-exit(2) if an THP crosses VMA boundary.
+counterproductive since in many cases partial unmap happens during exit(2) if
+a THP crosses a VMA boundary.
 
 Function deferred_split_huge_page() is used to queue page for splitting.
 The splitting itself will happen when we get memory pressure via shrinker
_
