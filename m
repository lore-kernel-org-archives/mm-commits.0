From: akpm@linux-foundation.org
Subject: [alternative-merged] scripts-tagssh-add-magic-for-declarations-of-popular-kernel-type.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:30:40 -0800
Message-ID: <20130114203041.D5A24100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:47310 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab3ANUan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:30:43 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so536335yen.5
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:30:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkhai@yandex.ru, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: add magic for declarations of popular kernel type
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-add-magic-for-declarations-of-popular-kernel-type.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Kirill Tkhai <tkhai@yandex.ru>
Subject: scripts/tags.sh: add magic for declarations of popular kernel type

1) Add magic for declarations of variables of popular kernel type like
   spinlock_t, list_head, wait_queue_head_t and other.

2) Add a set of specially handled declaration extentions like
   __attribute, __aligned and other.

3) Simplify pci_bus_* magic

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff -puN scripts/tags.sh~scripts-tagssh-add-magic-for-declarations-of-popular-kernel-type scripts/tags.sh
--- a/scripts/tags.sh~scripts-tagssh-add-magic-for-declarations-of-popular-kernel-type
+++ a/scripts/tags.sh
@@ -149,12 +149,17 @@ dogtags()
 exuberant()
 {
 	all_target_sources | xargs $1 -a                        \
-	-I __initdata,__exitdata,__acquires,__releases          \
-	-I __read_mostly,____cacheline_aligned                  \
+	-I __initdata,__exitdata,__initconst,__devinitdata	\
+	-I __devinitconst,__cpuinitdata,__initdata_memblock	\
+	-I __refdata,__attribute				\
+	-I __acquires,__releases,__deprecated			\
+	-I __read_mostly,__aligned,____cacheline_aligned        \
 	-I ____cacheline_aligned_in_smp                         \
 	-I ____cacheline_internodealigned_in_smp                \
+	-I __used,__packed,__packed2__,__must_check,__must_hold	\
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
+	-I static,const						\
 	--extra=+f --c-kinds=+px                                \
 	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
@@ -182,8 +187,19 @@ exuberant()
 	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
 	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
-	--regex-c='/PCI_OP_READ\(([a-z]*[a-z]).*[1-4]\)/pci_bus_read_config_\1/' \
-	--regex-c='/PCI_OP_WRITE\(([a-z]*[a-z]).*[1-4]\)/pci_bus_write_config_\1/'
+	--regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
+	--regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
+	--regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
+	--regex-c='/DEFINE_(RAW_SPINLOCK|RWLOCK|SEQLOCK)\((\w*)/\2/v/'	\
+	--regex-c='/DECLARE_(RWSEM|COMPLETION)\((\w*)/\2/v/'		\
+	--regex-c='/DECLARE_BITMAP\((\w*)/\1/v/'			\
+	--regex-c='/(^|\s)(|L|H)LIST_HEAD\((\w*)/\3/v/'			\
+	--regex-c='/(^|\s)RADIX_TREE\((\w*)/\2/v/'			\
+	--regex-c='/DEFINE_PER_CPU\(([^,]*,\s*)(\w*).*\)/\2/v/'		\
+	--regex-c='/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
+	--regex-c='/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/'		\
+	--regex-c='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
+	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -226,9 +242,20 @@ emacs()
 	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
 	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
-	--regex='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
-	--regex='/PCI_OP_READ\(([a-z]*[a-z]).*[1-4]\)/pci_bus_read_config_\1/' \
-	--regex='/PCI_OP_WRITE\(([a-z]*[a-z]).*[1-4]\)/pci_bus_write_config_\1/'
+	--regex='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'			\
+	--regex='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/'	\
+	--regex='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/'\
+	--regex='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
+	--regex='/DEFINE_(RAW_SPINLOCK|RWLOCK|SEQLOCK)\((\w*)/\2/v/'	\
+	--regex='/DECLARE_(RWSEM|COMPLETION)\((\w*)/\2/v/'		\
+	--regex='/DECLARE_BITMAP\((\w*)/\1/v/'				\
+	--regex='/(^|\s)(|L|H)LIST_HEAD\((\w*)/\3/v/'			\
+	--regex='/(^|\s)RADIX_TREE\((\w*)/\2/v/'			\
+	--regex='/DEFINE_PER_CPU\(([^,]*,\s*)(\w*).*\)/\2/v/'		\
+	--regex='/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
+	--regex='/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/'			\
+	--regex='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
+	--regex='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
_

Patches currently in -mm which might be from tkhai@yandex.ru are


