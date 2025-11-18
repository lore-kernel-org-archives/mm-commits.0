Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9417C349AE0
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763488318; cv=none; b=K7KoMMGPdQ7x7xWi2bLjtWUrO4u1EW+PAHEBLL9jh6YzQ7UupqpiftA9wXgRZCV2sbbhOeJK4ZJEaWh3CeAPdNv5BpLBk8BDgTsYWNi+e39XOwKDzxAce7GopTVwFe2uic8S7MFCGXixL/jrJcI3ocKJhNWsyOaBXYanca/K4is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763488318; c=relaxed/simple;
	bh=kE0f7Dz7p0YK820f6QKRqoh6QsWUVqYPCVGzhNVowt4=;
	h=Date:To:From:Subject:Message-Id; b=ptwRC4ZaOnGTosyNHvJgrfQQ/+QDOX14j6pKVlGp4h9SkGGd0xXcSGb91VQY4PDHIR1vGhFNIACyyRLLA+O6ElMu8JAOnBvI//+Lft3E8Ke2kx1JJS0v9YuDfzqYC8SeOf4DDMbPLxXXzQtK+ni8TQ4lYm7SMMBCFSYJZAyENAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UARz6E/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UARz6E/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8F0C19424;
	Tue, 18 Nov 2025 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763488318;
	bh=kE0f7Dz7p0YK820f6QKRqoh6QsWUVqYPCVGzhNVowt4=;
	h=Date:To:From:Subject:From;
	b=UARz6E/FFAfxpxS6raMV5R9MfBWanReL2qFa9u7lnNWE/ESKXhr0u0zlEqQ4os+pQ
	 u+EZWtyloz3Tld0NPK3KaLrInY3MKe+GJe22bu620lrlTpEVsHxMVPG8VWqrlHL8Lw
	 GFJ4LAvQNMnyQ6pKYVI/qI6qHSvgKcjzN+3UAyUQ=
Date: Tue, 18 Nov 2025 09:51:56 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,robh@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jack@suse.cz,debug@rivosinc.com,david@redhat.com,conor@kernel.org,conor.dooley@microchip.com,brauner@kernel.org,axelrasmussen@google.com,arnd@arndb.de,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,alex@ghiti.fr,ajones@ventanamicro.com,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dt-bindings-riscv-add-svrsw60t59b-extension-description.patch added to mm-new branch
Message-Id: <20251118175158.0C8F0C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dt-bindings: riscv: Add Svrsw60t59b extension description
has been added to the -mm mm-new branch.  Its filename is
     dt-bindings-riscv-add-svrsw60t59b-extension-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dt-bindings-riscv-add-svrsw60t59b-extension-description.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Subject: dt-bindings: riscv: Add Svrsw60t59b extension description
Date: Thu, 13 Nov 2025 15:28:06 +0800

Add description for the Svrsw60t59b extension (PTE Reserved for SW
bits 60:59) extension which was ratified recently in
riscv-non-isa/riscv-iommu.

Link: https://lkml.kernel.org/r/20251113072806.795029-7-zhangchunyan@iscas.ac.cn
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Conor Dooley <conor@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/riscv/extensions.yaml |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/devicetree/bindings/riscv/extensions.yaml~dt-bindings-riscv-add-svrsw60t59b-extension-description
+++ a/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -217,6 +217,12 @@ properties:
             memory types as ratified in the 20191213 version of the privileged
             ISA specification.
 
+        - const: svrsw60t59b
+          description:
+            The Svrsw60t59b extension for providing two more bits[60:59] to
+            PTE/PMD entry as ratified at commit 28bde925e7a7 ("PTE Reserved
+            for SW bits 60:59") of riscv-non-isa/riscv-iommu.
+
         - const: svvptc
           description:
             The standard Svvptc supervisor-level extension for
_

Patches currently in -mm which might be from zhangchunyan@iscas.ac.cn are

mm-softdirty-add-pgtable_supports_soft_dirty.patch
mm-userfaultfd-add-pgtable_supports_uffd_wp.patch
riscv-add-risc-v-svrsw60t59b-extension-support.patch
riscv-mm-add-soft-dirty-page-tracking-support.patch
riscv-mm-add-userfaultfd-write-protect-support.patch
dt-bindings-riscv-add-svrsw60t59b-extension-description.patch

