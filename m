From: akpm@linux-foundation.org
Subject: [merged] lib-debugobjects-export-for-use-in-modules.patch removed from -mm tree
Date: Thu, 01 Dec 2016 12:06:50 -0800
Message-ID: <584082da.Ufecrtb5a8tdWCL7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759196AbcLAUGv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2016 15:06:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, borntraeger@de.ibm.com, changbin.du@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/debugobjects: export for use in modules
has been removed from the -mm tree.  Its filename was
     lib-debugobjects-export-for-use-in-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: lib/debugobjects: export for use in modules

Drivers, or other modules, that use a mixture of objects (especially
objects embedded within other objects) would like to take advantage of
the debugobjects facilities to help catch misuse. Currently, the
debugobjects interface is only available to builtin drivers and requires
a set of EXPORT_SYMBOL_GPL for use by modules.

I am using the debugobjects in i915.ko to try and catch some invalid
operations on embedded objects.  The problem currently only presents
itself across module unload so forcing i915 to be builtin is not an
option.

Link: http://lkml.kernel.org/r/20161122143039.6433-1-chris@chris-wilson.co.uk
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "Du, Changbin" <changbin.du@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN lib/debugobjects.c~lib-debugobjects-export-for-use-in-modules lib/debugobjects.c
--- a/lib/debugobjects.c~lib-debugobjects-export-for-use-in-modules
+++ a/lib/debugobjects.c
@@ -362,6 +362,7 @@ void debug_object_init(void *addr, struc
 
 	__debug_object_init(addr, descr, 0);
 }
+EXPORT_SYMBOL_GPL(debug_object_init);
 
 /**
  * debug_object_init_on_stack - debug checks when an object on stack is
@@ -376,6 +377,7 @@ void debug_object_init_on_stack(void *ad
 
 	__debug_object_init(addr, descr, 1);
 }
+EXPORT_SYMBOL_GPL(debug_object_init_on_stack);
 
 /**
  * debug_object_activate - debug checks when an object is activated
@@ -449,6 +451,7 @@ int debug_object_activate(void *addr, st
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(debug_object_activate);
 
 /**
  * debug_object_deactivate - debug checks when an object is deactivated
@@ -496,6 +499,7 @@ void debug_object_deactivate(void *addr,
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
+EXPORT_SYMBOL_GPL(debug_object_deactivate);
 
 /**
  * debug_object_destroy - debug checks when an object is destroyed
@@ -542,6 +546,7 @@ void debug_object_destroy(void *addr, st
 out_unlock:
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
+EXPORT_SYMBOL_GPL(debug_object_destroy);
 
 /**
  * debug_object_free - debug checks when an object is freed
@@ -582,6 +587,7 @@ void debug_object_free(void *addr, struc
 out_unlock:
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
+EXPORT_SYMBOL_GPL(debug_object_free);
 
 /**
  * debug_object_assert_init - debug checks when object should be init-ed
@@ -626,6 +632,7 @@ void debug_object_assert_init(void *addr
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
+EXPORT_SYMBOL_GPL(debug_object_assert_init);
 
 /**
  * debug_object_active_state - debug checks object usage state machine
@@ -673,6 +680,7 @@ debug_object_active_state(void *addr, st
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
+EXPORT_SYMBOL_GPL(debug_object_active_state);
 
 #ifdef CONFIG_DEBUG_OBJECTS_FREE
 static void __debug_check_no_obj_freed(const void *address, unsigned long size)
_

Patches currently in -mm which might be from chris@chris-wilson.co.uk are


