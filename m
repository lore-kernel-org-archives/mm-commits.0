Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F1932D0DE
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774464938; cv=none; b=YERCSqtgiROI5BeG6EqPkAcZ8fY2zeKyTyA0dcQPrpAJyPVXwOn1D/tklWJJMtZUfBgrE0Q9Smjf2haRCZvZjz2e2dvNcsW4zekkYibWM1bkTkCwI4BJzXhxfXu7WadN0zrdujFs7l2fDv2vHoi/71Mu3eyTlJk0t0GQ24XW05Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774464938; c=relaxed/simple;
	bh=T35CbGD4Yyx2arXXfZE4fh4ER3Y2fOnFQ5qVXzfjEFs=;
	h=Date:To:From:Subject:Message-Id; b=Jl3SeIgKEszmzLHM+GtpwZ+4j929OUxCFSCSvcoLL7SUzOt4kzLWtCiFfjiRhSAmo9c9x6f2yHlJYmp8fE1z1/EqKOszeaPcJoqxCmNWGXr+a1rDwVDJKr5Tj22slCp4wmnm2Tk0JNw0ACD98JqPe88QZbZ5gOhVbweof4OYQYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QrXnj2oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QrXnj2oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B653BC4CEF7;
	Wed, 25 Mar 2026 18:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774464937;
	bh=T35CbGD4Yyx2arXXfZE4fh4ER3Y2fOnFQ5qVXzfjEFs=;
	h=Date:To:From:Subject:From;
	b=QrXnj2oj+gn2q8KDtkSeEKtfV/fNbHB6kIOqjEKxdauPNbXe86Xj2l2Y3IQOu9hmM
	 G+nb9kqeGEWZ4Kc3oU3QCAoUUeJ8sBYZWzjZDXigeRpsUUdrzodSKog2zymdKaP3yc
	 r+V2xvYpIox6vbr636L9wE+zosMQSng6pgE1Uqz0=
Date: Wed, 25 Mar 2026 11:55:37 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,bblock@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch removed from -mm tree
Message-Id: <20260325185537.B653BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: debugobjects: allow to configure the amount of pre-allocated objects
has been removed from the -mm tree.  Its filename was
     debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Benjamin Block <bblock@linux.ibm.com>
Subject: debugobjects: allow to configure the amount of pre-allocated objects
Date: Wed, 25 Feb 2026 17:05:08 +0100

To debug object operations a certain amount of metadata has to be kept per
object that is tracked.  During boot a static amount of preallocated
objects are set aside to be used for this task until a dynamic allocator
can be used.  Once a dynamic allocator can be used an initial amount of
objects are pre-allocated to be used when needed.

So far the amount of such initially statically, and later dynamically
pre-allocated objects is set fixed at `64 * 16 = 1024`.  But depending on
the system this might not be enough during boot, when only the static
amount of pre-allocated objects is used; and once this happens ODEBUG
disables itself permanently.

On s390 it has been observed, that even with 16384 such pre-allocated
objects ODEBUG would still be disabled during boot.

Similarly to other debug features like KMEMLEAK add a Kconfig option
CONFIG_DEBUG_OBJECTS_POOL_SIZE_SHIFT that allows to increase the amount of
pre-allocated objects (in both the static and later dynamic cases).  Use
it as exponential, rather than linear value to allow for head-room to grow
into once set in a configuration.

The calculation is done as such:
    N_OBJECTS = 2^DEBUG_OBJECTS_POOL_SIZE_SHIFT * N_BATCH

By default it is set to 6, so the actual amount is unchanged, unless
the new options is changed:
    N_OBJECTS = 2^6 * 16
    N_OBJECTS = 1024

For the previously mentioned observations on s390 it was necessary to
increase the option to 11 in order to have enough space during boot.

Link: https://lkml.kernel.org/r/70f06193b3c3581802710ebcef74671e50c4c979.1772035270.git.bblock@linux.ibm.com
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug  |   32 ++++++++++++++++++++++++++++++++
 lib/debugobjects.c |   15 +++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

--- a/lib/debugobjects.c~debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects
+++ a/lib/debugobjects.c
@@ -22,11 +22,18 @@
 #define ODEBUG_HASH_BITS	14
 #define ODEBUG_HASH_SIZE	(1 << ODEBUG_HASH_BITS)
 
-/* Must be power of two */
+/*
+ * Must be power of two.
+ * Please change Kconfig help text of DEBUG_OBJECTS_POOL_SIZE_SHIFT when
+ * changed.
+ */
 #define ODEBUG_BATCH_SIZE	16
 
+#define ODEBUG_POOL_SHIFT	CONFIG_DEBUG_OBJECTS_POOL_SIZE_SHIFT
+static_assert(ODEBUG_POOL_SHIFT >= 0);
+
 /* Initial values. Must all be a multiple of batch size */
-#define ODEBUG_POOL_SIZE	(64 * ODEBUG_BATCH_SIZE)
+#define ODEBUG_POOL_SIZE	((1 << ODEBUG_POOL_SHIFT) * ODEBUG_BATCH_SIZE)
 #define ODEBUG_POOL_MIN_LEVEL	(ODEBUG_POOL_SIZE / 4)
 
 #define ODEBUG_POOL_PERCPU_SIZE	(8 * ODEBUG_BATCH_SIZE)
@@ -586,6 +593,10 @@ static void debug_objects_oom(void)
 	struct debug_bucket *db = obj_hash;
 	HLIST_HEAD(freelist);
 
+	/*
+	 * Please change Kconfig help text of DEBUG_OBJECTS_POOL_SIZE_SHIFT
+	 * when changed.
+	 */
 	pr_warn("Out of memory. ODEBUG disabled\n");
 
 	for (int i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
--- a/lib/Kconfig.debug~debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects
+++ a/lib/Kconfig.debug
@@ -812,6 +812,38 @@ config DEBUG_OBJECTS_PERCPU_COUNTER
 	  percpu counter routines to track the life time of percpu counter
 	  objects and validate the percpu counter operations.
 
+config DEBUG_OBJECTS_POOL_SIZE_SHIFT
+	int "Metadata objects pool size"
+	depends on DEBUG_OBJECTS
+	range 0 21
+	default 6
+	help
+	  To debug object operations a certain amount of metadata has to be
+	  kept per object that is tracked. During boot a static amount of pre-
+	  allocated objects is set aside to be used for this task until such a
+	  time a dynamic allocator can be used. Once a dynamic allocator can be
+	  used an initial amount of objects is pre-allocated to be used when
+	  needed.
+
+	  This option sets the amount of both: the amount of initially
+	  statically allocated objects; and later the amount of dynamically
+	  pre-allocated objects. It is used as exponent to the power of 2,
+	  multiplied by the batch size used to set how many objects are move
+	  between pools at once.
+
+	  For example, when left at the default of 6:
+	      N_OBJECTS = 2^DEBUG_OBJECTS_POOL_SIZE_SHIFT * N_BATCH
+	      N_OBJECTS = 2^6 * 16
+	      N_OBJECTS = 1024
+	  By increasing the option by 1, you double the amount of objects.
+
+	  An indication that you need to increase this option is that during
+	  boot you see messages like this:
+	      ODEBUG: Out of memory. ODEBUG disabled
+
+	  If in doubt, leave the default.
+
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
 	range 0 1
_

Patches currently in -mm which might be from bblock@linux.ibm.com are


