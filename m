From: akpm@linux-foundation.org
Subject: - docs-kernel-locking-convert-semaphore-references.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:30 -0800
Message-ID: <200802070024.m170OBqO006586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47925 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934416AbYBGArp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:47:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     docs: kernel-locking: Convert semaphore references
has been removed from the -mm tree.  Its filename was
     docs-kernel-locking-convert-semaphore-references.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docs: kernel-locking: Convert semaphore references
From: Daniel Walker <dwalker@mvista.com>

I converted some of the document to reflect mutex usage instead of
semaphore usage.  Since we shouldin't be promoting semaphore usage when
it's on it's way out..

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-locking.tmpl |   32 ++++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN Documentation/DocBook/kernel-locking.tmpl~docs-kernel-locking-convert-semaphore-references Documentation/DocBook/kernel-locking.tmpl
--- a/Documentation/DocBook/kernel-locking.tmpl~docs-kernel-locking-convert-semaphore-references
+++ a/Documentation/DocBook/kernel-locking.tmpl
@@ -717,7 +717,7 @@ used, and when it gets full, throws out 
     <para>
 For our first example, we assume that all operations are in user
 context (ie. from system calls), so we can sleep.  This means we can
-use a semaphore to protect the cache and all the objects within
+use a mutex to protect the cache and all the objects within
 it.  Here's the code:
     </para>
 
@@ -725,7 +725,7 @@ it.  Here's the code:
 #include &lt;linux/list.h&gt;
 #include &lt;linux/slab.h&gt;
 #include &lt;linux/string.h&gt;
-#include &lt;asm/semaphore.h&gt;
+#include &lt;linux/mutex.h&gt;
 #include &lt;asm/errno.h&gt;
 
 struct object
@@ -737,7 +737,7 @@ struct object
 };
 
 /* Protects the cache, cache_num, and the objects within it */
-static DECLARE_MUTEX(cache_lock);
+static DEFINE_MUTEX(cache_lock);
 static LIST_HEAD(cache);
 static unsigned int cache_num = 0;
 #define MAX_CACHE_SIZE 10
@@ -789,17 +789,17 @@ int cache_add(int id, const char *name)
         obj-&gt;id = id;
         obj-&gt;popularity = 0;
 
-        down(&amp;cache_lock);
+        mutex_lock(&amp;cache_lock);
         __cache_add(obj);
-        up(&amp;cache_lock);
+        mutex_unlock(&amp;cache_lock);
         return 0;
 }
 
 void cache_delete(int id)
 {
-        down(&amp;cache_lock);
+        mutex_lock(&amp;cache_lock);
         __cache_delete(__cache_find(id));
-        up(&amp;cache_lock);
+        mutex_unlock(&amp;cache_lock);
 }
 
 int cache_find(int id, char *name)
@@ -807,13 +807,13 @@ int cache_find(int id, char *name)
         struct object *obj;
         int ret = -ENOENT;
 
-        down(&amp;cache_lock);
+        mutex_lock(&amp;cache_lock);
         obj = __cache_find(id);
         if (obj) {
                 ret = 0;
                 strcpy(name, obj-&gt;name);
         }
-        up(&amp;cache_lock);
+        mutex_unlock(&amp;cache_lock);
         return ret;
 }
 </programlisting>
@@ -853,7 +853,7 @@ The change is shown below, in standard p
          int popularity;
  };
 
--static DECLARE_MUTEX(cache_lock);
+-static DEFINE_MUTEX(cache_lock);
 +static spinlock_t cache_lock = SPIN_LOCK_UNLOCKED;
  static LIST_HEAD(cache);
  static unsigned int cache_num = 0;
@@ -870,22 +870,22 @@ The change is shown below, in standard p
          obj-&gt;id = id;
          obj-&gt;popularity = 0;
 
--        down(&amp;cache_lock);
+-        mutex_lock(&amp;cache_lock);
 +        spin_lock_irqsave(&amp;cache_lock, flags);
          __cache_add(obj);
--        up(&amp;cache_lock);
+-        mutex_unlock(&amp;cache_lock);
 +        spin_unlock_irqrestore(&amp;cache_lock, flags);
          return 0;
  }
 
  void cache_delete(int id)
  {
--        down(&amp;cache_lock);
+-        mutex_lock(&amp;cache_lock);
 +        unsigned long flags;
 +
 +        spin_lock_irqsave(&amp;cache_lock, flags);
          __cache_delete(__cache_find(id));
--        up(&amp;cache_lock);
+-        mutex_unlock(&amp;cache_lock);
 +        spin_unlock_irqrestore(&amp;cache_lock, flags);
  }
 
@@ -895,14 +895,14 @@ The change is shown below, in standard p
          int ret = -ENOENT;
 +        unsigned long flags;
 
--        down(&amp;cache_lock);
+-        mutex_lock(&amp;cache_lock);
 +        spin_lock_irqsave(&amp;cache_lock, flags);
          obj = __cache_find(id);
          if (obj) {
                  ret = 0;
                  strcpy(name, obj-&gt;name);
          }
--        up(&amp;cache_lock);
+-        mutex_unlock(&amp;cache_lock);
 +        spin_unlock_irqrestore(&amp;cache_lock, flags);
          return ret;
  }
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
driver-base-memory-semaphore-to-mutex.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
