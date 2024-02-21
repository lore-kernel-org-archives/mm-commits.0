Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFC7127B70
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708558921; cv=none; b=hCE72so/45CxSudceOxt+ybq1MRwmeNcKlTKVWh2NXqCveakvA8jgOKcgzxY0/+mDv0qzsmSlMn0ClgvAcZGZLZ3PfIy4hh00kkZU8pPXytX4AwdHTlXekXhynjwhB3U98Z7AQYgPGIH1F/+e1bliMBOwB1ZgoxFYg5GCJFWbIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708558921; c=relaxed/simple;
	bh=h9bXRIWO8o5hHZnSwvup7U45VhnuqOM3LMcshxui2vs=;
	h=Date:To:From:Subject:Message-Id; b=EcdtBccBW12HF6KSbeMTS/MGQo3WiuVz90UvwOSmU0dvBpLMnAG10ObTmD8j63MBaOWGmDU/CtoZVjTkKFXUUHdGlCvGKADPX/0Ofr0w8hm8JOqj9pq66zTzGweiXHCJX5iecrWOATLqlPdUv+s5r7ptprNy2UC5gj4e8/EA/zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YCz4O3L0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YCz4O3L0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FC8C433F1;
	Wed, 21 Feb 2024 23:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708558921;
	bh=h9bXRIWO8o5hHZnSwvup7U45VhnuqOM3LMcshxui2vs=;
	h=Date:To:From:Subject:From;
	b=YCz4O3L0R7Y4qCRQBD4FMq8ggeut/w+JiJztn5qk44mZwF7RP4SNGbtG4h0kKX/og
	 8Qrl7YEtIYoxYoZNNViT5pO350ZQjMF50duRKzXNkqvhDGiUpqpvDb2siJPgczCeH3
	 MYBFs6kalmlpkG4SnX4XwyucS23XmSXEgfWVwqIU=
Date: Wed, 21 Feb 2024 15:42:00 -0800
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch removed from -mm tree
Message-Id: <20240221234201.06FC8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix
Date: Sat Jan 27 07:13:46 PM PST 2024

fix build

In file included from ./include/linux/mmzone.h:1425,
                 from ./include/linux/gfp.h:7,
                 from ./include/linux/slab.h:16,
                 from ./include/linux/crypto.h:17,
                 from arch/x86/kernel/asm-offsets.c:9:
./include/linux/memory_hotplug.h:282:13: warning: 'mhp_supports_memmap_on_memory' defined but not used [-Wunused-function]
  282 | static bool mhp_supports_memmap_on_memory(void)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix
+++ a/include/linux/memory_hotplug.h
@@ -279,7 +279,7 @@ static inline bool movable_node_is_enabl
 	return false;
 }
 
-static bool mhp_supports_memmap_on_memory(void)
+static inline bool mhp_supports_memmap_on_memory(void)
 {
 	return false;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

