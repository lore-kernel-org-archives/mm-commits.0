From: akpm@linux-foundation.org
Subject: +
 mmu_notifier-add-call_srcu-and-sync-function-for-listener-to-delay-call-and-sync.patch added to -mm tree
Date: Mon, 04 Aug 2014 16:00:00 -0700
Message-ID: <53e01070.6akEkOam3/R3PWfu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:52933 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaHDXAB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2014 19:00:01 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so30175obb.0
        for <mm-commits@vger.kernel.org>; Mon, 04 Aug 2014 16:00:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, jglisse@redhat.com, oded.gabbay@amd.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmu_notifier: add call_srcu and sync function for listene=
r to delay call and sync
has been added to the -mm tree.  Its filename is
     mmu_notifier-add-call_srcu-and-sync-function-for-listener-to-delay=
-call-and-sync.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmu_notifier-add-call_srcu=
-and-sync-function-for-listener-to-delay-call-and-sync.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmu_notifier-add-call_srcu=
-and-sync-function-for-listener-to-delay-call-and-sync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Peter Zijlstra <peterz@infradead.org>
Subject: mmu_notifier: add call_srcu and sync function for listener to =
delay call and sync


When kernel device drivers or subsystems want to bind their lifespan to=
 t=3D
he lifespan of the mm_struct, they usually use one of the following
methods:

1.  Manually calling a function in the interested kernel module.  The
   funct=3D ion call needs to be placed in mmput.  This method was reje=
cted
   by several ker=3D nel maintainers.

2. Registering to the mmu notifier release mechanism.

The problem with the latter approach is that the mmu_notifier_release c=
al=3D
lback is called from__mmu_notifier_release (called from exit_mmap).  Th=
at
functi=3D on iterates over the list of mmu notifiers and don't expect t=
he
release call=3D back function to remove itself from the list.  Therefor=
e,
the callback function=3D in the kernel module can't release the
mmu_notifier_object, which is actuall=3D y the kernel module's object
itself.  As a result, the destruction of the kernel module's object mus=
t
to be done in a delayed fashion.

This patch adds support for this delayed callback, by adding a new
mmu_notifier_call_srcu function that receives a function ptr and calls =
th=3D
at function with call_srcu.  In that function, the kernel module releas=
es
its object.  To use mmu_notifier_call_srcu, the calling module needs to
call b=3D efore that a new function called
mmu_notifier_unregister_no_release that as its=3D name implies, unregis=
ters
a notifier without calling its notifier release call=3D back.

This patch also adds a function that will call barrier_srcu so those ke=
rn=3D
el modules can sync with mmu_notifier.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: J=E9r=F4me Glisse <jglisse@redhat.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    6 ++++
 mm/mmu_notifier.c            |   40 ++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff -puN include/linux/mmu_notifier.h~mmu_notifier-add-call_srcu-and-s=
ync-function-for-listener-to-delay-call-and-sync include/linux/mmu_noti=
fier.h
--- a/include/linux/mmu_notifier.h~mmu_notifier-add-call_srcu-and-sync-=
function-for-listener-to-delay-call-and-sync
+++ a/include/linux/mmu_notifier.h
@@ -170,6 +170,8 @@ extern int __mmu_notifier_register(struc
 				   struct mm_struct *mm);
 extern void mmu_notifier_unregister(struct mmu_notifier *mn,
 				    struct mm_struct *mm);
+extern void mmu_notifier_unregister_no_release(struct mmu_notifier *mn=
,
+					       struct mm_struct *mm);
 extern void __mmu_notifier_mm_destroy(struct mm_struct *mm);
 extern void __mmu_notifier_release(struct mm_struct *mm);
 extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
@@ -288,6 +290,10 @@ static inline void mmu_notifier_mm_destr
 	set_pte_at(___mm, ___address, __ptep, ___pte);			\
 })
=20
+extern void mmu_notifier_call_srcu(struct rcu_head *rcu,
+				   void (*func)(struct rcu_head *rcu));
+extern void mmu_notifier_synchronize(void);
+
 #else /* CONFIG_MMU_NOTIFIER */
=20
 static inline void mmu_notifier_release(struct mm_struct *mm)
diff -puN mm/mmu_notifier.c~mmu_notifier-add-call_srcu-and-sync-functio=
n-for-listener-to-delay-call-and-sync mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mmu_notifier-add-call_srcu-and-sync-function-fo=
r-listener-to-delay-call-and-sync
+++ a/mm/mmu_notifier.c
@@ -23,6 +23,25 @@
 static struct srcu_struct srcu;
=20
 /*
+ * This function allows mmu_notifier::release callback to delay a call=
 to
+ * a function that will free appropriate resources. The function must =
be
+ * quick and must not block.
+ */
+void mmu_notifier_call_srcu(struct rcu_head *rcu,
+			    void (*func)(struct rcu_head *rcu))
+{
+	call_srcu(&srcu, rcu, func);
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_call_srcu);
+
+void mmu_notifier_synchronize(void)
+{
+	/* Wait for any running method to finish. */
+	srcu_barrier(&srcu);
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_synchronize);
+
+/*
  * This function can't run concurrently against mmu_notifier_register
  * because mm->mm_users > 0 during mmu_notifier_register and exit_mmap
  * runs with mm_users =3D=3D 0. Other tasks may still invoke mmu notif=
iers
@@ -53,7 +72,6 @@ void __mmu_notifier_release(struct mm_st
 		 */
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
-	srcu_read_unlock(&srcu, id);
=20
 	spin_lock(&mm->mmu_notifier_mm->lock);
 	while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
@@ -69,6 +87,7 @@ void __mmu_notifier_release(struct mm_st
 		hlist_del_init_rcu(&mn->hlist);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
+	srcu_read_unlock(&srcu, id);
=20
 	/*
 	 * synchronize_srcu here prevents mmu_notifier_release from returning=
 to
@@ -325,6 +344,25 @@ void mmu_notifier_unregister(struct mmu_
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_unregister);
=20
+/*
+ * Same as mmu_notifier_unregister but no callback and no srcu synchro=
nization.
+ */
+void mmu_notifier_unregister_no_release(struct mmu_notifier *mn,
+					struct mm_struct *mm)
+{
+	spin_lock(&mm->mmu_notifier_mm->lock);
+	/*
+	 * Can not use list_del_rcu() since __mmu_notifier_release
+	 * can delete it before we hold the lock.
+	 */
+	hlist_del_init_rcu(&mn->hlist);
+	spin_unlock(&mm->mmu_notifier_mm->lock);
+
+	BUG_ON(atomic_read(&mm->mm_count) <=3D 0);
+	mmdrop(mm);
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_unregister_no_release);
+
 static int __init mmu_notifier_init(void)
 {
 	return init_srcu_struct(&srcu);
_

Patches currently in -mm which might be from peterz@infradead.org are

vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.p=
atch
mmu_notifier-add-call_srcu-and-sync-function-for-listener-to-delay-call=
-and-sync.patch
makefile-tell-gcc-optimizer-to-never-introduce-new-data-races.patch
linux-next.patch
x86-vdso-fix-vdso2cs-special_pages-error-checking.patch
timer-provide-an-api-for-deferrable-timeout.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.pat=
ch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix=
-2.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
