From: akpm@linux-foundation.org
Subject: + kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch added to -mm tree
Date: Mon, 23 Nov 2009 14:19:06 -0800
Message-ID: <200911232219.nANMJ7J1020201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757414AbZKWWTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 17:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, ak@linux.intel.com, arnd@arndb.de, gregkh@suse.de, mchehab@redhat.com


The patch titled
     kfifo: add DEFINE_KFIFO and friends, add very tiny functions
has been added to the -mm tree.  Its filename is
     kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch

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
Subject: kfifo: add DEFINE_KFIFO and friends, add very tiny functions
From: Stefani Seibold <stefani@seibold.net>

 Add DECLARE_KFIFO - macro to declare a kfifo and the associated buffer inside a struct
 Add INIT_KFIFO - Initialize a kfifo declared by DECLARED_KFIFO
 Add DEFINE_KFIFO - macro to define and initialize a kfifo as a global or local object
 Add kfifo_size() - returns the size of the fifo in bytes
 Add kfifo_is_empty() - returns true if the fifo is empty
 Add kfifo_is_full() - returns true if the fifo is full
 Add kfifo_avail() - returns the number of bytes available in the FIFO
 Do some code cleanup

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   91 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 2 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-add-define_kfifo-and-friends-add-very-tiny-functions include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-add-define_kfifo-and-friends-add-very-tiny-functions
+++ a/include/linux/kfifo.h
@@ -51,6 +51,57 @@ struct kfifo {
 	unsigned int out;	/* data is extracted from off. (out % size) */
 };
 
+/*
+ * Macros for declaration and initialization of the kfifo datatype
+ */
+
+#define __kfifo_initializer(s, b) \
+	(struct kfifo) { \
+		.size	= s, \
+		.in	= 0, \
+		.out	= 0, \
+		.buffer = b \
+	}
+
+/**
+ * DECLARE_KFIFO - macro to declare a kfifo and the associated buffer
+ * @name: name of the declared kfifo datatype
+ * @size: size of the fifo buffer
+ *
+ * Note: the macro can be used inside struct or union declaration
+ * Note: the macro creates two objects:
+ *  A kfifo object with the given name and a buffer for the kfifo
+ *  object named name##kfifo_buffer
+ */
+#define DECLARE_KFIFO(name, size) \
+union { \
+	struct kfifo name; \
+	unsigned char name##kfifo_buffer[size + sizeof(struct kfifo)]; \
+}
+
+/**
+ * INIT_KFIFO - Initialize a kfifo declared by DECLARED_KFIFO
+ * @name: name of the declared kfifo datatype
+ * @size: size of the fifo buffer
+ */
+#define INIT_KFIFO(name) \
+	name = __kfifo_initializer(sizeof(name##kfifo_buffer) - \
+				sizeof(struct kfifo), name##kfifo_buffer)
+
+/**
+ * DEFINE_KFIFO - macro to define and initialize a kfifo
+ * @name: name of the declared kfifo datatype
+ * @size: size of the fifo buffer
+ *
+ * Note: the macro can be used for global and local kfifo data type variables
+ * Note: the macro creates two objects:
+ *  A kfifo object with the given name and a buffer for the kfifo
+ *  object named name##kfifo_buffer
+ */
+#define DEFINE_KFIFO(name, size) \
+	unsigned char name##kfifo_buffer[size]; \
+	struct kfifo name = __kfifo_initializer(size, name##kfifo_buffer)
+
 extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
 			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
@@ -71,6 +122,15 @@ static inline void kfifo_reset(struct kf
 }
 
 /**
+ * kfifo_size - returns the size of the fifo in bytes
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check unsigned int kfifo_size(struct kfifo *fifo)
+{
+	return fifo->size;
+}
+
+/**
  * kfifo_len - returns the number of used bytes in the FIFO
  * @fifo: the fifo to be used.
  */
@@ -84,6 +144,33 @@ static inline unsigned int kfifo_len(str
 }
 
 /**
+ * kfifo_is_empty - returns true if the fifo is empty
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check int kfifo_is_empty(struct kfifo *fifo)
+{
+	return fifo->in == fifo->out;
+}
+
+/**
+ * kfifo_is_full - returns true if the fifo is full
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check int kfifo_is_full(struct kfifo *fifo)
+{
+	return kfifo_len(fifo) == kfifo_size(fifo);
+}
+
+/**
+ * kfifo_avail - returns the number of bytes available in the FIFO
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check unsigned int kfifo_avail(struct kfifo *fifo)
+{
+	return kfifo_size(fifo) - kfifo_len(fifo);
+}
+
+/**
  * kfifo_in_locked - puts some data into the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
  * @from: the data to be added.
@@ -133,8 +220,8 @@ static inline __must_check unsigned int 
 	 * optimization: if the FIFO is empty, set the indices to 0
 	 * so we don't wrap the next time
 	 */
-	if (fifo->in == fifo->out)
-		fifo->in = fifo->out = 0;
+	if (kfifo_is_empty(fifo))
+		kfifo_reset(fifo);
 
 	spin_unlock_irqrestore(lock, flags);
 
_

Patches currently in -mm which might be from stefani@seibold.net are

kfifo-move-struct-kfifo-in-place.patch
kfifo-move-out-spinlock.patch
kfifo-cleanup-namespace.patch
kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch
kfifo-add-kfifo_skip-kfifo_from_user-and-kfifo_to_user.patch
kfifo-add-record-handling-functions.patch

