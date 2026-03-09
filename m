Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A382512DE
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 19:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773083790; cv=none; b=sNTe5dgBAjCeNFFsY9E6+cH/AidfE75VVJ1vFJ4RlMRBeUd/OWjRDRG5HFK7/XKAk8sRlpusmY7DxT4NM2Q4OPhDTE8NK2RUeam5gdFIS19UA/2D2I/vll5MooNWKJffg89s+p+AErGT550fmKkX9fMUaLHKLMV480gGe7/WsNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773083790; c=relaxed/simple;
	bh=oiP8pp+nuss9IlbvQA3VRlcTBv8ETgWx/bKzR6klyrA=;
	h=Date:To:From:Subject:Message-Id; b=mtsHTf5OOBVic186PPkp/b/2QDUNfj7JiZqgRshw0B+FCXxxFiYEp74llQrZt3+SUzaaxR9f17SYl7+ti+lHJcmdMIORV2stpv2LBnV5EDx14K0wTumu+jsib2VHppDmhplcpeyiDuxL7Zez22m5gLHD1rsD4iZUG1snzI3gCfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I0cRIGBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I0cRIGBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A38C2BC87;
	Mon,  9 Mar 2026 19:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773083789;
	bh=oiP8pp+nuss9IlbvQA3VRlcTBv8ETgWx/bKzR6klyrA=;
	h=Date:To:From:Subject:From;
	b=I0cRIGBgoTnzdv3rMSIPbKlIXQHCeaTCZNivXn4N4Aw2qFKSWi9hMlNrbGd0Fg7WM
	 TXecvRJnPmXpjVzzgZWFKipbvzBIjaptR6xfYngkGlW9armbwsU6/5ckCf8k43KHj4
	 OEK2DBRnMTQYTY9cFISlqLZg63utRYmayYYe0ukA=
Date: Mon, 09 Mar 2026 12:16:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-prevent-droppable-mappings-from-being-locked-fix.patch removed from -mm tree
Message-Id: <20260309191629.B1A38C2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-prevent-droppable-mappings-from-being-locked-fix
has been removed from the -mm tree.  Its filename was
     mm-prevent-droppable-mappings-from-being-locked-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm-prevent-droppable-mappings-from-being-locked-fix
Date: Sat, 7 Mar 2026 13:23:50 -0800

fix build

Link: https://lkml.kernel.org/r/dae49547-48d9-4abd-9fb1-05250fcd7d23@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202603070433.MUXyiGWN-lkp@intel.com/
Closes: https://lkml.kernel.org/r/aaujSXGjGBv5NVAD@rli9-mobl
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/include/dup.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/vma/include/dup.h~mm-prevent-droppable-mappings-from-being-locked-fix
+++ a/tools/testing/vma/include/dup.h
@@ -350,6 +350,9 @@ enum {
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* This mask prevents VMAs from being mlock'd */
+#define VM_NO_MLOCK_MASK       (VM_SPECIAL | VM_DROPPABLE)
+
 #define TASK_EXEC ((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0)
 
 #define VM_DATA_FLAGS_TSK_EXEC	(VM_READ | VM_WRITE | TASK_EXEC | \
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are


