From: akpm@linux-foundation.org
Subject: - lib-remove-fastcall-from-lib.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:15:35 -0800
Message-ID: <200802082015.m18KFGEV010516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762769AbYBHUql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:46:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib: remove fastcall from lib/*
has been removed from the -mm tree.  Its filename was
     lib-remove-fastcall-from-lib.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: remove fastcall from lib/*
From: Harvey Harrison <harvey.harrison@gmail.com>

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iomap.c              |   32 ++++++++++++++++----------------
 lib/rwsem-spinlock.c     |   16 ++++++++--------
 lib/semaphore-sleepers.c |    8 ++++----
 3 files changed, 28 insertions(+), 28 deletions(-)

diff -puN lib/iomap.c~lib-remove-fastcall-from-lib lib/iomap.c
--- a/lib/iomap.c~lib-remove-fastcall-from-lib
+++ a/lib/iomap.c
@@ -69,27 +69,27 @@ static void bad_io_access(unsigned long 
 #define mmio_read32be(addr) be32_to_cpu(__raw_readl(addr))
 #endif
 
-unsigned int fastcall ioread8(void __iomem *addr)
+unsigned int ioread8(void __iomem *addr)
 {
 	IO_COND(addr, return inb(port), return readb(addr));
 	return 0xff;
 }
-unsigned int fastcall ioread16(void __iomem *addr)
+unsigned int ioread16(void __iomem *addr)
 {
 	IO_COND(addr, return inw(port), return readw(addr));
 	return 0xffff;
 }
-unsigned int fastcall ioread16be(void __iomem *addr)
+unsigned int ioread16be(void __iomem *addr)
 {
 	IO_COND(addr, return pio_read16be(port), return mmio_read16be(addr));
 	return 0xffff;
 }
-unsigned int fastcall ioread32(void __iomem *addr)
+unsigned int ioread32(void __iomem *addr)
 {
 	IO_COND(addr, return inl(port), return readl(addr));
 	return 0xffffffff;
 }
-unsigned int fastcall ioread32be(void __iomem *addr)
+unsigned int ioread32be(void __iomem *addr)
 {
 	IO_COND(addr, return pio_read32be(port), return mmio_read32be(addr));
 	return 0xffffffff;
@@ -110,23 +110,23 @@ EXPORT_SYMBOL(ioread32be);
 #define mmio_write32be(val,port) __raw_writel(be32_to_cpu(val),port)
 #endif
 
-void fastcall iowrite8(u8 val, void __iomem *addr)
+void iowrite8(u8 val, void __iomem *addr)
 {
 	IO_COND(addr, outb(val,port), writeb(val, addr));
 }
-void fastcall iowrite16(u16 val, void __iomem *addr)
+void iowrite16(u16 val, void __iomem *addr)
 {
 	IO_COND(addr, outw(val,port), writew(val, addr));
 }
-void fastcall iowrite16be(u16 val, void __iomem *addr)
+void iowrite16be(u16 val, void __iomem *addr)
 {
 	IO_COND(addr, pio_write16be(val,port), mmio_write16be(val, addr));
 }
-void fastcall iowrite32(u32 val, void __iomem *addr)
+void iowrite32(u32 val, void __iomem *addr)
 {
 	IO_COND(addr, outl(val,port), writel(val, addr));
 }
-void fastcall iowrite32be(u32 val, void __iomem *addr)
+void iowrite32be(u32 val, void __iomem *addr)
 {
 	IO_COND(addr, pio_write32be(val,port), mmio_write32be(val, addr));
 }
@@ -193,15 +193,15 @@ static inline void mmio_outsl(void __iom
 }
 #endif
 
-void fastcall ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
 {
 	IO_COND(addr, insb(port,dst,count), mmio_insb(addr, dst, count));
 }
-void fastcall ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
 {
 	IO_COND(addr, insw(port,dst,count), mmio_insw(addr, dst, count));
 }
-void fastcall ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
 {
 	IO_COND(addr, insl(port,dst,count), mmio_insl(addr, dst, count));
 }
@@ -209,15 +209,15 @@ EXPORT_SYMBOL(ioread8_rep);
 EXPORT_SYMBOL(ioread16_rep);
 EXPORT_SYMBOL(ioread32_rep);
 
-void fastcall iowrite8_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite8_rep(void __iomem *addr, const void *src, unsigned long count)
 {
 	IO_COND(addr, outsb(port, src, count), mmio_outsb(addr, src, count));
 }
-void fastcall iowrite16_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite16_rep(void __iomem *addr, const void *src, unsigned long count)
 {
 	IO_COND(addr, outsw(port, src, count), mmio_outsw(addr, src, count));
 }
-void fastcall iowrite32_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite32_rep(void __iomem *addr, const void *src, unsigned long count)
 {
 	IO_COND(addr, outsl(port, src,count), mmio_outsl(addr, src, count));
 }
diff -puN lib/rwsem-spinlock.c~lib-remove-fastcall-from-lib lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c~lib-remove-fastcall-from-lib
+++ a/lib/rwsem-spinlock.c
@@ -125,7 +125,7 @@ __rwsem_wake_one_writer(struct rw_semaph
 /*
  * get a read lock on the semaphore
  */
-void fastcall __sched __down_read(struct rw_semaphore *sem)
+void __sched __down_read(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
@@ -168,7 +168,7 @@ void fastcall __sched __down_read(struct
 /*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */
-int fastcall __down_read_trylock(struct rw_semaphore *sem)
+int __down_read_trylock(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -191,7 +191,7 @@ int fastcall __down_read_trylock(struct 
  * get a write lock on the semaphore
  * - we increment the waiting count anyway to indicate an exclusive lock
  */
-void fastcall __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
+void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
@@ -231,7 +231,7 @@ void fastcall __sched __down_write_neste
 	;
 }
 
-void fastcall __sched __down_write(struct rw_semaphore *sem)
+void __sched __down_write(struct rw_semaphore *sem)
 {
 	__down_write_nested(sem, 0);
 }
@@ -239,7 +239,7 @@ void fastcall __sched __down_write(struc
 /*
  * trylock for writing -- returns 1 if successful, 0 if contention
  */
-int fastcall __down_write_trylock(struct rw_semaphore *sem)
+int __down_write_trylock(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -260,7 +260,7 @@ int fastcall __down_write_trylock(struct
 /*
  * release a read lock on the semaphore
  */
-void fastcall __up_read(struct rw_semaphore *sem)
+void __up_read(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -275,7 +275,7 @@ void fastcall __up_read(struct rw_semaph
 /*
  * release a write lock on the semaphore
  */
-void fastcall __up_write(struct rw_semaphore *sem)
+void __up_write(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -292,7 +292,7 @@ void fastcall __up_write(struct rw_semap
  * downgrade a write lock into a read lock
  * - just wake up any readers at the front of the queue
  */
-void fastcall __downgrade_write(struct rw_semaphore *sem)
+void __downgrade_write(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
diff -puN lib/semaphore-sleepers.c~lib-remove-fastcall-from-lib lib/semaphore-sleepers.c
--- a/lib/semaphore-sleepers.c~lib-remove-fastcall-from-lib
+++ a/lib/semaphore-sleepers.c
@@ -48,12 +48,12 @@
  *    we cannot lose wakeup events.
  */
 
-fastcall void __up(struct semaphore *sem)
+void __up(struct semaphore *sem)
 {
 	wake_up(&sem->wait);
 }
 
-fastcall void __sched __down(struct semaphore * sem)
+void __sched __down(struct semaphore *sem)
 {
 	struct task_struct *tsk = current;
 	DECLARE_WAITQUEUE(wait, tsk);
@@ -90,7 +90,7 @@ fastcall void __sched __down(struct sema
 	tsk->state = TASK_RUNNING;
 }
 
-fastcall int __sched __down_interruptible(struct semaphore * sem)
+int __sched __down_interruptible(struct semaphore *sem)
 {
 	int retval = 0;
 	struct task_struct *tsk = current;
@@ -153,7 +153,7 @@ fastcall int __sched __down_interruptibl
  * single "cmpxchg" without failure cases,
  * but then it wouldn't work on a 386.
  */
-fastcall int __down_trylock(struct semaphore * sem)
+int __down_trylock(struct semaphore *sem)
 {
 	int sleepers;
 	unsigned long flags;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
