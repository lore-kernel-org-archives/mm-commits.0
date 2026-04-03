Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4E634D91F
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198558; cv=none; b=ZZvk7FntNso/iQCJWB3aapMaKs8qXL14DIMV158/ecA0+VR4qW/+jnvcokeGDLI8TqLEooPw7QpEzQ2dH9nh9RZNjnVOJblagWWPep951887EpETpYSyMhwsWeN8pUByfioD1Q59bOWK0dGcS4Mg1CL7Fea3LTPO8FHo+GpchDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198558; c=relaxed/simple;
	bh=YFxjFSgvE6D8yAlx9J3jo3Tp+1gsPXfSF5ox9alFw+c=;
	h=Date:To:From:Subject:Message-Id; b=uQqHiq5loXDjZNnJI33dAOMrN2iIXXFyzPMLkqbttfrG9FVZ9vANkLTc1cWuefXZncnoHapq/C2/joolAZtZxPXygm3I1NhNV4YaGGM+9aoNw103AGV7GwAME5ZzQyjPhZ2EE+m2wEt5AbEpYKgSVp23wleq8Qo8kgQJ0vG3gIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JfDhquLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JfDhquLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92874C4CEF7;
	Fri,  3 Apr 2026 06:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198558;
	bh=YFxjFSgvE6D8yAlx9J3jo3Tp+1gsPXfSF5ox9alFw+c=;
	h=Date:To:From:Subject:From;
	b=JfDhquLo6Ep2GItxL4h+Hd5e4rCYFr+mkX1GkTX+argG08vLKWi3YtAnCXDWB0CQS
	 Cnu7d44YgKYy7D+E8A6b3oJbhPA/RCnCQYCgI9KVQWxTiUoYNS9QzEEJS9TKjv6Dj1
	 NOtI6gmsU3OrXqyOUVuLmei9E+UKzSBlVdTXqDiE=
Date: Thu, 02 Apr 2026 23:42:38 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tstaudt@de.ibm.com,sourabhjain@linux.ibm.com,ryncsn@gmail.com,robh@kernel.org,krzk@kernel.org,kernelfans@gmail.com,dyoung@redhat.com,chleroy@kernel.org,bhe@redhat.com,arnaud.lefebvre@clever-cloud.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm64ppc64le-kdump-pass-dm-crypt-keys-to-kdump-kernel.patch removed from -mm tree
Message-Id: <20260403064238.92874C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64,ppc64le/kdump: pass dm-crypt keys to kdump kernel
has been removed from the -mm tree.  Its filename was
     arm64ppc64le-kdump-pass-dm-crypt-keys-to-kdump-kernel.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Coiby Xu <coxu@redhat.com>
Subject: arm64,ppc64le/kdump: pass dm-crypt keys to kdump kernel
Date: Wed, 25 Feb 2026 14:03:46 +0800

CONFIG_CRASH_DM_CRYPT has been introduced to support LUKS-encrypted
device dump target by addressing two challenges [1],
 - Kdump kernel may not be able to decrypt the LUKS partition. For some
   machines, a system administrator may not have a chance to enter the
   password to decrypt the device in kdump initramfs after the 1st kernel
   crashes

 - LUKS2 by default use the memory-hard Argon2 key derivation function
   which is quite memory-consuming compared to the limited memory reserved
   for kdump.

To also enable this feature for ARM64 and PowerPC, the missing piece is to
let the kdump kernel know where to find the dm-crypt keys which are
randomly stored in memory reserved for kdump.  Introduce a new device tree
property dmcryptkeys [2] as similar to elfcorehdr to pass the memory
address of the stored info of dm-crypt keys to the kdump kernel.  Since
this property is only needed by the kdump kernel, it won't be exposed to
userspace.

Link: https://lkml.kernel.org/r/20260225060347.718905-4-coxu@redhat.com
Link: https://lore.kernel.org/all/20250502011246.99238-1-coxu@redhat.com/ [1]
Link: https://github.com/devicetree-org/dt-schema/pull/181 [2]
Signed-off-by: Coiby Xu <coxu@redhat.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Thomas Staudt <tstaudt@de.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/machine_kexec_file.c |    4 ++++
 arch/powerpc/kexec/elf_64.c            |    4 ++++
 drivers/of/fdt.c                       |   21 +++++++++++++++++++++
 drivers/of/kexec.c                     |   19 +++++++++++++++++++
 4 files changed, 48 insertions(+)

--- a/arch/arm64/kernel/machine_kexec_file.c~arm64ppc64le-kdump-pass-dm-crypt-keys-to-kdump-kernel
+++ a/arch/arm64/kernel/machine_kexec_file.c
@@ -134,6 +134,10 @@ int load_other_segments(struct kimage *i
 
 		kexec_dprintk("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
 			      image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
+
+		ret = crash_load_dm_crypt_keys(image);
+		if (ret)
+			goto out_err;
 	}
 #endif
 
--- a/arch/powerpc/kexec/elf_64.c~arm64ppc64le-kdump-pass-dm-crypt-keys-to-kdump-kernel
+++ a/arch/powerpc/kexec/elf_64.c
@@ -79,6 +79,10 @@ static void *elf64_load(struct kimage *i
 			goto out;
 		}
 
+		ret = crash_load_dm_crypt_keys(image);
+		if (ret)
+			goto out;
+
 		/* Setup cmdline for kdump kernel case */
 		modified_cmdline = setup_kdump_cmdline(image, cmdline,
 						       cmdline_len);
--- a/drivers/of/fdt.c~arm64ppc64le-kdump-pass-dm-crypt-keys-to-kdump-kernel
+++ a/drivers/of/fdt.c
@@ -866,6 +866,26 @@ static void __init early_init_dt_check_f
 		 elfcorehdr_addr, elfcorehdr_size);
 }
 
+static void __init early_init_dt_check_for_dmcryptkeys(unsigned long node)
+{
+	const char *prop_name = "linux,dmcryptkeys";
+	const __be32 *prop;
+
+	if (!IS_ENABLED(CONFIG_CRASH_DM_CRYPT))
+		return;
+
+	pr_debug("Looking for dmcryptkeys property... ");
+
+	prop = of_get_flat_dt_prop(node, prop_name, NULL);
+	if (!prop)
+		return;
+
+	dm_crypt_keys_addr = dt_mem_next_cell(dt_root_addr_cells, &prop);
+
+	/* Property only accessible to crash dump kernel */
+	fdt_delprop(initial_boot_params, node, prop_name);
+}
+
 static unsigned long chosen_node_offset = -FDT_ERR_NOTFOUND;
 
 /*
@@ -1097,6 +1117,7 @@ int __init early_init_dt_scan_chosen(cha
 
 	early_init_dt_check_for_initrd(node);
 	early_init_dt_check_for_elfcorehdr(node);
+	early_init_dt_check_for_dmcryptkeys(node);
 
 	rng_seed = of_get_flat_dt_prop(node, "rng-seed", &l);
 	if (rng_seed && l > 0) {
--- a/drivers/of/kexec.c~arm64ppc64le-kdump-pass-dm-crypt-keys-to-kdump-kernel
+++ a/drivers/of/kexec.c
@@ -423,6 +423,25 @@ void *of_kexec_alloc_and_setup_fdt(const
 		if (ret)
 			goto out;
 
+		if (image->dm_crypt_keys_addr != 0) {
+			ret = fdt_appendprop_addrrange(fdt, 0, chosen_node,
+						       "linux,dmcryptkeys",
+						       image->dm_crypt_keys_addr,
+						       image->dm_crypt_keys_sz);
+
+			if (ret)
+				goto out;
+
+			/*
+			 * Avoid dmcryptkeys from being stomped on in kdump kernel by
+			 * setting up memory reserve map.
+			 */
+			ret = fdt_add_mem_rsv(fdt, image->dm_crypt_keys_addr,
+					      image->dm_crypt_keys_sz);
+			if (ret)
+				goto out;
+		}
+
 #ifdef CONFIG_CRASH_DUMP
 		/* add linux,usable-memory-range */
 		ret = fdt_appendprop_addrrange(fdt, 0, chosen_node,
_

Patches currently in -mm which might be from coxu@redhat.com are


