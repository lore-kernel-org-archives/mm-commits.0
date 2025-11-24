Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E5F335082
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025870; cv=none; b=BFJFLAXD8kgeSbz7F9FzdhANsuduhOjxzk4TSokajX+9dGJB1sUmj7ATT9lc1CyF946wn5QxhPP4mG/q/w1PUcx3oT1vGqnS6Qd35PQORO9bmpiyk8vz+yZU1FPIibuIAS5gC3JpjU21Gg2qxipbUMtuGhFK9ydDhpnxzG5gdJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025870; c=relaxed/simple;
	bh=0xmM2DLel9Fldz8ZHxH03Q/78saKhO8jn4ALNQGq/ys=;
	h=Date:To:From:Subject:Message-Id; b=GtiOFr55AnvBrrxRIsaS6wjAmkUCZ4VubqvLYl+jQcKZE7W/+r3ItTsPFpCQZmTiQFSuoIGjZD0CuOYDu3ZEG4Na/b+KpLAg2ZBALbIQfHTgGcZkMV/qYQA6KGl6Tz4q7HGKRJLdE/c8UzApUNmxMW8tciuEv/rbXu+XvTGcH0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EzEj5Snh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EzEj5Snh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1781C4CEF1;
	Mon, 24 Nov 2025 23:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025869;
	bh=0xmM2DLel9Fldz8ZHxH03Q/78saKhO8jn4ALNQGq/ys=;
	h=Date:To:From:Subject:From;
	b=EzEj5SnhMuWmMUzpzcHtWlHYjGMklu6JC46RlcUjEru5aR5cTAjaJHSQ3sMuCiK84
	 jixESDDzM2GogCAdAEdRDRM9tywmEVv2rSWXogj+k11gAlFVIXu1bWgi9pSzrxxhHV
	 K6vsRbEpTacLo7NOVc3Y0seP9gCQLRyz2p5KklO0=
Date: Mon, 24 Nov 2025 15:11:09 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,robh@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jack@suse.cz,debug@rivosinc.com,david@redhat.com,conor@kernel.org,conor.dooley@microchip.com,brauner@kernel.org,axelrasmussen@google.com,arnd@arndb.de,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,alex@ghiti.fr,ajones@ventanamicro.com,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dt-bindings-riscv-add-svrsw60t59b-extension-description.patch removed from -mm tree
Message-Id: <20251124231109.B1781C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dt-bindings: riscv: Add Svrsw60t59b extension description
has been removed from the -mm tree.  Its filename was
     dt-bindings-riscv-add-svrsw60t59b-extension-description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


