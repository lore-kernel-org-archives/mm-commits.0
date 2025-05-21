Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25387289E0B
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849739; cv=none; b=eMIsROYA7OZPFSa+bxefxigrnOGngHYOj2hmdZhMC+uXigkMbLCOl+Ceawk/HGN4G60SWKDhbtjq94I8qM6zu2Yvwf1mf37bNCyeWkuQeMMaSPB/L9tKH7cj13GwhCFaETBuglePsJj73Z9u6Dksw8P9pHje52KvmMjvHuc55D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849739; c=relaxed/simple;
	bh=6F/dxBSCNKgwmq5san4Vzhkpa+bCw6RgqyncbMoEkQE=;
	h=Date:To:From:Subject:Message-Id; b=SRTdHhgHyW8qD0huoTGVOzUUCRH6gsYOOGPev4noAprHLhH18FyFZ+huW2NsXFOnHn+49dSaS/iQEdKuEXE+UwEscsD/GfZQIFQAQa3emEk83pCkazL09PJOdzJ9EKGEhk89QniYdOKftnpIv3YJ0ZfSiFEBounSA8hd1ZxBxJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ncV2J+0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ncV2J+0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68B1C4CEE4;
	Wed, 21 May 2025 17:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849738;
	bh=6F/dxBSCNKgwmq5san4Vzhkpa+bCw6RgqyncbMoEkQE=;
	h=Date:To:From:Subject:From;
	b=ncV2J+0ed/xFA+J3DAgxPUwYsj/rOoqxi1nNGmlhqINTiZu+R+znAHzKPjGKGkuyz
	 ufDC7WjyHqLMCt3bvPd4iaYUxLVNSrmZURy0io8F4W3zOMNgFflgp15WzdNMUCNPJL
	 7ns2IGzbQAqQM7yZAt/RNs70D0bVZhh5cX0TQIWQ=
Date: Wed, 21 May 2025 10:48:58 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,bhe@redhat.com,berrange@redhat.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-crash-pass-dm-crypt-keys-to-kdump-kernel.patch removed from -mm tree
Message-Id: <20250521174858.C68B1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/crash: pass dm crypt keys to kdump kernel
has been removed from the -mm tree.  Its filename was
     x86-crash-pass-dm-crypt-keys-to-kdump-kernel.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Coiby Xu <coxu@redhat.com>
Subject: x86/crash: pass dm crypt keys to kdump kernel
Date: Fri, 2 May 2025 09:12:41 +0800

1st kernel will build up the kernel command parameter dmcryptkeys as
similar to elfcorehdr to pass the memory address of the stored info of dm
crypt key to kdump kernel.

Link: https://lkml.kernel.org/r/20250502011246.99238-8-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jan Pazdziora <jpazdziora@redhat.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    4 +--
 arch/x86/kernel/crash.c                   |   26 ++++++++++++++++++--
 arch/x86/kernel/kexec-bzimage64.c         |   21 ++++++++++++++++
 3 files changed, 47 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/crash.c~x86-crash-pass-dm-crypt-keys-to-kdump-kernel
+++ a/arch/x86/kernel/crash.c
@@ -278,6 +278,7 @@ static int memmap_exclude_ranges(struct
 				 unsigned long long mend)
 {
 	unsigned long start, end;
+	int ret;
 
 	cmem->ranges[0].start = mstart;
 	cmem->ranges[0].end = mend;
@@ -286,22 +287,43 @@ static int memmap_exclude_ranges(struct
 	/* Exclude elf header region */
 	start = image->elf_load_addr;
 	end = start + image->elf_headers_sz - 1;
-	return crash_exclude_mem_range(cmem, start, end);
+	ret = crash_exclude_mem_range(cmem, start, end);
+
+	if (ret)
+		return ret;
+
+	/* Exclude dm crypt keys region */
+	if (image->dm_crypt_keys_addr) {
+		start = image->dm_crypt_keys_addr;
+		end = start + image->dm_crypt_keys_sz - 1;
+		return crash_exclude_mem_range(cmem, start, end);
+	}
+
+	return ret;
 }
 
 /* Prepare memory map for crash dump kernel */
 int crash_setup_memmap_entries(struct kimage *image, struct boot_params *params)
 {
+	unsigned int nr_ranges = 0;
 	int i, ret = 0;
 	unsigned long flags;
 	struct e820_entry ei;
 	struct crash_memmap_data cmd;
 	struct crash_mem *cmem;
 
-	cmem = vzalloc(struct_size(cmem, ranges, 1));
+	/*
+	 * Using random kexec_buf for passing dm crypt keys may cause a range
+	 * split. So use two slots here.
+	 */
+	nr_ranges = 2;
+	cmem = vzalloc(struct_size(cmem, ranges, nr_ranges));
 	if (!cmem)
 		return -ENOMEM;
 
+	cmem->max_nr_ranges = nr_ranges;
+	cmem->nr_ranges = 0;
+
 	memset(&cmd, 0, sizeof(struct crash_memmap_data));
 	cmd.params = params;
 
--- a/arch/x86/kernel/kexec-bzimage64.c~x86-crash-pass-dm-crypt-keys-to-kdump-kernel
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -27,6 +27,8 @@
 #include <asm/kexec-bzimage64.h>
 
 #define MAX_ELFCOREHDR_STR_LEN	30	/* elfcorehdr=0x<64bit-value> */
+#define MAX_DMCRYPTKEYS_STR_LEN	31	/* dmcryptkeys=0x<64bit-value> */
+
 
 /*
  * Defines lowest physical address for various segments. Not sure where
@@ -76,6 +78,10 @@ static int setup_cmdline(struct kimage *
 	if (image->type == KEXEC_TYPE_CRASH) {
 		len = sprintf(cmdline_ptr,
 			"elfcorehdr=0x%lx ", image->elf_load_addr);
+
+		if (image->dm_crypt_keys_addr != 0)
+			len += sprintf(cmdline_ptr + len,
+					"dmcryptkeys=0x%lx ", image->dm_crypt_keys_addr);
 	}
 	memcpy(cmdline_ptr + len, cmdline, cmdline_len);
 	cmdline_len += len;
@@ -441,6 +447,19 @@ static void *bzImage64_load(struct kimag
 		ret = crash_load_segments(image);
 		if (ret)
 			return ERR_PTR(ret);
+		ret = crash_load_dm_crypt_keys(image);
+		if (ret == -ENOENT) {
+			kexec_dprintk("No dm crypt key to load\n");
+		} else if (ret) {
+			pr_err("Failed to load dm crypt keys\n");
+			return ERR_PTR(ret);
+		}
+		if (image->dm_crypt_keys_addr &&
+		    cmdline_len + MAX_ELFCOREHDR_STR_LEN + MAX_DMCRYPTKEYS_STR_LEN >
+			    header->cmdline_size) {
+			pr_err("Appending dmcryptkeys=<addr> to command line exceeds maximum allowed length\n");
+			return ERR_PTR(-EINVAL);
+		}
 	}
 #endif
 
@@ -468,6 +487,8 @@ static void *bzImage64_load(struct kimag
 	efi_map_sz = efi_get_runtime_map_size();
 	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len +
 				MAX_ELFCOREHDR_STR_LEN;
+	if (image->dm_crypt_keys_addr)
+		params_cmdline_sz += MAX_DMCRYPTKEYS_STR_LEN;
 	params_cmdline_sz = ALIGN(params_cmdline_sz, 16);
 	kbuf.bufsz = params_cmdline_sz + ALIGN(efi_map_sz, 16) +
 				sizeof(struct setup_data) +
--- a/Documentation/admin-guide/kdump/kdump.rst~x86-crash-pass-dm-crypt-keys-to-kdump-kernel
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -551,8 +551,8 @@ Write the dump file to encrypted disk vo
 ============================================
 
 CONFIG_CRASH_DM_CRYPT can be enabled to support saving the dump file to an
-encrypted disk volume. User space can interact with
-/sys/kernel/config/crash_dm_crypt_keys for setup,
+encrypted disk volume (only x86_64 supported for now). User space can interact
+with /sys/kernel/config/crash_dm_crypt_keys for setup,
 
 1. Tell the first kernel what logon keys are needed to unlock the disk volumes,
     # Add key #1
_

Patches currently in -mm which might be from coxu@redhat.com are


