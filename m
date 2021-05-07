Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F61EC43462
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2990613CD
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhEGBHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhEGBHF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93FED613C8;
        Fri,  7 May 2021 01:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349567;
        bh=30dXyCHotCwWphZrcicy0glsTe5shE3iMCmewp80oI4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OAaZlEkk2FRLSodIkRT5oNMct9Knufpc2fLtzf3YSR0aZXdX2Yu3qFsclv832Xw3c
         2jvkAOozvPuYFSSw7odcP2PMoyVszFDmtI99QL3K3lcvnO0LmrjkkaVJRUAfKa4NbW
         IUEgf55SS8OjWtHvtAvZ2V9M5x3Ad/4KwTqmRwho=
Date:   Thu, 06 May 2021 18:06:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        gregkh@linuxfoundation.org, hdanton@sina.com,
        huang.ying.caritas@gmail.com, linux-mm@kvack.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 76/91] mm/vmalloc: remove vwrite()
Message-ID: <20210507010606.NS9JjpNt_%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/vmalloc: remove vwrite()

The last user (/dev/kmem) is gone. Let's drop it.

Link: https://lkml.kernel.org/r/20210324102351.6932-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: huang ying <huang.ying.caritas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 
 mm/nommu.c              |   10 ---
 mm/vmalloc.c            |  116 --------------------------------------
 3 files changed, 1 insertion(+), 126 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-remove-vwrite
+++ a/include/linux/vmalloc.h
@@ -229,7 +229,6 @@ static inline void set_vm_flush_reset_pe
 
 /* for /proc/kcore */
 extern long vread(char *buf, char *addr, unsigned long count);
-extern long vwrite(char *buf, char *addr, unsigned long count);
 
 /*
  *	Internals.  Dont't use..
--- a/mm/nommu.c~mm-vmalloc-remove-vwrite
+++ a/mm/nommu.c
@@ -210,16 +210,6 @@ long vread(char *buf, char *addr, unsign
 	return count;
 }
 
-long vwrite(char *buf, char *addr, unsigned long count)
-{
-	/* Don't allow overflow */
-	if ((unsigned long) addr + count < count)
-		count = -(unsigned long) addr;
-
-	memcpy(addr, buf, count);
-	return count;
-}
-
 /*
  *	vmalloc  -  allocate virtually contiguous memory
  *
--- a/mm/vmalloc.c~mm-vmalloc-remove-vwrite
+++ a/mm/vmalloc.c
@@ -3146,10 +3146,7 @@ static int aligned_vread(char *buf, char
 		 * kmap() and get small overhead in this access function.
 		 */
 		if (p) {
-			/*
-			 * we can expect USER0 is not used (see vread/vwrite's
-			 * function description)
-			 */
+			/* We can expect USER0 is not used -- see vread() */
 			void *map = kmap_atomic(p);
 			memcpy(buf, map + offset, length);
 			kunmap_atomic(map);
@@ -3164,43 +3161,6 @@ static int aligned_vread(char *buf, char
 	return copied;
 }
 
-static int aligned_vwrite(char *buf, char *addr, unsigned long count)
-{
-	struct page *p;
-	int copied = 0;
-
-	while (count) {
-		unsigned long offset, length;
-
-		offset = offset_in_page(addr);
-		length = PAGE_SIZE - offset;
-		if (length > count)
-			length = count;
-		p = vmalloc_to_page(addr);
-		/*
-		 * To do safe access to this _mapped_ area, we need
-		 * lock. But adding lock here means that we need to add
-		 * overhead of vmalloc()/vfree() calles for this _debug_
-		 * interface, rarely used. Instead of that, we'll use
-		 * kmap() and get small overhead in this access function.
-		 */
-		if (p) {
-			/*
-			 * we can expect USER0 is not used (see vread/vwrite's
-			 * function description)
-			 */
-			void *map = kmap_atomic(p);
-			memcpy(map + offset, buf, length);
-			kunmap_atomic(map);
-		}
-		addr += length;
-		buf += length;
-		copied += length;
-		count -= length;
-	}
-	return copied;
-}
-
 /**
  * vread() - read vmalloc area in a safe way.
  * @buf:     buffer for reading data
@@ -3283,80 +3243,6 @@ finished:
 	return buflen;
 }
 
-/**
- * vwrite() - write vmalloc area in a safe way.
- * @buf:      buffer for source data
- * @addr:     vm address.
- * @count:    number of bytes to be read.
- *
- * This function checks that addr is a valid vmalloc'ed area, and
- * copy data from a buffer to the given addr. If specified range of
- * [addr...addr+count) includes some valid address, data is copied from
- * proper area of @buf. If there are memory holes, no copy to hole.
- * IOREMAP area is treated as memory hole and no copy is done.
- *
- * If [addr...addr+count) doesn't includes any intersects with alive
- * vm_struct area, returns 0. @buf should be kernel's buffer.
- *
- * Note: In usual ops, vwrite() is never necessary because the caller
- * should know vmalloc() area is valid and can use memcpy().
- * This is for routines which have to access vmalloc area without
- * any information, as /dev/kmem.
- *
- * Return: number of bytes for which addr and buf should be
- * increased (same number as @count) or %0 if [addr...addr+count)
- * doesn't include any intersection with valid vmalloc area
- */
-long vwrite(char *buf, char *addr, unsigned long count)
-{
-	struct vmap_area *va;
-	struct vm_struct *vm;
-	char *vaddr;
-	unsigned long n, buflen;
-	int copied = 0;
-
-	/* Don't allow overflow */
-	if ((unsigned long) addr + count < count)
-		count = -(unsigned long) addr;
-	buflen = count;
-
-	spin_lock(&vmap_area_lock);
-	list_for_each_entry(va, &vmap_area_list, list) {
-		if (!count)
-			break;
-
-		if (!va->vm)
-			continue;
-
-		vm = va->vm;
-		vaddr = (char *) vm->addr;
-		if (addr >= vaddr + get_vm_area_size(vm))
-			continue;
-		while (addr < vaddr) {
-			if (count == 0)
-				goto finished;
-			buf++;
-			addr++;
-			count--;
-		}
-		n = vaddr + get_vm_area_size(vm) - addr;
-		if (n > count)
-			n = count;
-		if (!(vm->flags & VM_IOREMAP)) {
-			aligned_vwrite(buf, addr, n);
-			copied++;
-		}
-		buf += n;
-		addr += n;
-		count -= n;
-	}
-finished:
-	spin_unlock(&vmap_area_lock);
-	if (!copied)
-		return 0;
-	return buflen;
-}
-
 /**
  * remap_vmalloc_range_partial - map vmalloc pages to userspace
  * @vma:		vma to cover
_
