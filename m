From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-fix-migrate_zspage-zs_free-race-condition.patch removed from -mm tree
Date: Thu, 21 Jan 2016 14:58:32 -0800
Message-ID: <56a16298.6UwCOITythod6HvS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbcAUW6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junil0814.lee@lge.com, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix migrate_zspage-zs_free race condition
has been removed from the -mm tree.  Its filename was
     zsmalloc-fix-migrate_zspage-zs_free-race-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junil Lee <junil0814.lee@lge.com>
Subject: zsmalloc: fix migrate_zspage-zs_free race condition

record_obj() in migrate_zspage() does not preserve handle's
HANDLE_PIN_BIT, set by find_aloced_obj()->trypin_tag(), and implicitly
(accidentally) un-pins the handle, while migrate_zspage() still performs
an explicit unpin_tag() on the that handle.
This additional explicit unpin_tag() introduces a race condition with
zs_free(), which can pin that handle by this time, so the handle becomes
un-pinned.

Schematically, it goes like this:

CPU0					CPU1
migrate_zspage
  find_alloced_obj
    trypin_tag
      set HANDLE_PIN_BIT			zs_free()
						  pin_tag()
  obj_malloc() -- new object, no tag
  record_obj() -- remove HANDLE_PIN_BIT	    set HANDLE_PIN_BIT
  unpin_tag()  -- remove zs_free's HANDLE_PIN_BIT

The race condition may result in a NULL pointer dereference:
	Unable to handle kernel NULL pointer dereference at virtual address 00000000
	CPU: 0 PID: 19001 Comm: CookieMonsterCl Tainted:
	PC is at get_zspage_mapping+0x0/0x24
	LR is at obj_free.isra.22+0x64/0x128
	Call trace:
		[<ffffffc0001a3aa8>] get_zspage_mapping+0x0/0x24
		[<ffffffc0001a4918>] zs_free+0x88/0x114
		[<ffffffc00053ae54>] zram_free_page+0x64/0xcc
		[<ffffffc00053af4c>] zram_slot_free_notify+0x90/0x108
		[<ffffffc000196638>] swap_entry_free+0x278/0x294
		[<ffffffc000199008>] free_swap_and_cache+0x38/0x11c
		[<ffffffc0001837ac>] unmap_single_vma+0x480/0x5c8
		[<ffffffc000184350>] unmap_vmas+0x44/0x60
		[<ffffffc00018a53c>] exit_mmap+0x50/0x110
		[<ffffffc00009e408>] mmput+0x58/0xe0
		[<ffffffc0000a2854>] do_exit+0x320/0x8dc
		[<ffffffc0000a3cb4>] do_group_exit+0x44/0xa8
		[<ffffffc0000ae1bc>] get_signal+0x538/0x580
		[<ffffffc000087e44>] do_signal+0x98/0x4b8
		[<ffffffc00008843c>] do_notify_resume+0x14/0x5c

This patch keeps the lock bit in migration path and update
value atomically.

Signed-off-by: Junil Lee <junil0814.lee@lge.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: <stable@vger.kernel.org>	[4.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-migrate_zspage-zs_free-race-condition mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-migrate_zspage-zs_free-race-condition
+++ a/mm/zsmalloc.c
@@ -309,7 +309,12 @@ static void free_handle(struct zs_pool *
 
 static void record_obj(unsigned long handle, unsigned long obj)
 {
-	*(unsigned long *)handle = obj;
+	/*
+	 * lsb of @obj represents handle lock while other bits
+	 * represent object value the handle is pointing so
+	 * updating shouldn't do store tearing.
+	 */
+	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
 
 /* zpool driver */
@@ -1635,6 +1640,13 @@ static int migrate_zspage(struct zs_pool
 		free_obj = obj_malloc(d_page, class, handle);
 		zs_object_copy(free_obj, used_obj, class);
 		index++;
+		/*
+		 * record_obj updates handle's value to free_obj and it will
+		 * invalidate lock bit(ie, HANDLE_PIN_BIT) of handle, which
+		 * breaks synchronization using pin_tag(e,g, zs_free) so
+		 * let's keep the lock bit.
+		 */
+		free_obj |= BIT(HANDLE_PIN_BIT);
 		record_obj(handle, free_obj);
 		unpin_tag(handle);
 		obj_free(pool, class, used_obj);
_

Patches currently in -mm which might be from junil0814.lee@lge.com are


