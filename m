Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11056C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E081E2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196195;
	bh=1ozc0FmlPQKG8YakivD7RekgwS/8dPR1x8OuyDuoQXM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ODGTB+KakpU9X2k+3MtktyZNLzS69rIf5UKXR9jv++KO3Jc0NXX7iyLz4GjSqZGNy
	 cZYS3cgrHw67K8N8rb3nsRe2SZMGJ6skVdfO9LZSnDxIuQWV15quxJl+akvlwdKHXO
	 dlKBH65ISktu6DObwKO/PORLljlV7fpIjK3tiXjY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHLBgf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBgf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45105206B2;
        Wed, 12 Aug 2020 01:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196194;
        bh=1ozc0FmlPQKG8YakivD7RekgwS/8dPR1x8OuyDuoQXM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QRCJ+3LMCFv9J2hZrk3GZGA0z10wLnJtr11lOcHzZyxRAJJZmGN2TRqoNXehLgttZ
         uwN3ldSmAJ0xSxnHWzuxHfvYeotMgUGcDIBiiygH9tc49iIUyoF+eicP5kAr9US5T3
         iu6J6IylOHDqilmCNm5QRGjI/FCMqzi5xnwQuDPA=
Date:   Tue, 11 Aug 2020 18:36:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, dyoung@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, tyhicks@linux.microsoft.com,
        vgoyal@redhat.com, vijayb@linux.microsoft.com
Subject:  [patch 119/165] kdump: append kernel build-id string to
 VMCOREINFO
Message-ID: <20200812013633.IPGWH-Pam%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vijay Balakrishna <vijayb@linux.microsoft.com>
Subject: kdump: append kernel build-id string to VMCOREINFO

Make kernel GNU build-id available in VMCOREINFO.  Having build-id in
VMCOREINFO facilitates presenting appropriate kernel namelist image with
debug information file to kernel crash dump analysis tools.  Currently
VMCOREINFO lacks uniquely identifiable key for crash analysis automation.

Regarding if this patch is necessary or matching of linux_banner and
OSRELEASE in VMCOREINFO employed by crash(8) meets the need -- IMO,
build-id approach more foolproof, in most instances it is a cryptographic
hash generated using internal code/ELF bits unlike kernel version string
upon which linux_banner is based that is external to the code.  I feel
each is intended for a different purpose.  Also OSRELEASE is not suitable
when two different kernel builds from same version with different features
enabled.

Currently for most linux (and non-linux) systems build-id can be extracted
using standard methods for file types such as user mode crash dumps,
shared libraries, loadable kernel modules etc., This is an exception for
linux kernel dump.  Having build-id in VMCOREINFO brings some uniformity
for automation tools.

Tyler said:

: I think this is a nice improvement over today's linux_banner approach for
: correlating vmlinux to a kernel dump.
: 
: The elf notes parsing in this patch lines up with what is described in in
: the "Notes (Nhdr)" section of the elf(5) man page.
: 
: BUILD_ID_MAX is sufficient to hold a sha1 build-id, which is the default
: build-id type today in GNU ld(2).  It is also sufficient to hold the
: "fast" build-id, which is the default build-id type today in LLVM lld(2).

Link: http://lkml.kernel.org/r/1591849672-34104-1-git-send-email-vijayb@linux.microsoft.com
Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_core.h |    6 ++++
 kernel/crash_core.c        |   50 +++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

--- a/include/linux/crash_core.h~kdump-append-kernel-build-id-string-to-vmcoreinfo
+++ a/include/linux/crash_core.h
@@ -38,6 +38,8 @@ phys_addr_t paddr_vmcoreinfo_note(void);
 
 #define VMCOREINFO_OSRELEASE(value) \
 	vmcoreinfo_append_str("OSRELEASE=%s\n", value)
+#define VMCOREINFO_BUILD_ID(value) \
+	vmcoreinfo_append_str("BUILD-ID=%s\n", value)
 #define VMCOREINFO_PAGESIZE(value) \
 	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
 #define VMCOREINFO_SYMBOL(name) \
@@ -64,6 +66,10 @@ extern unsigned char *vmcoreinfo_data;
 extern size_t vmcoreinfo_size;
 extern u32 *vmcoreinfo_note;
 
+/* raw contents of kernel .notes section */
+extern const void __start_notes __weak;
+extern const void __stop_notes __weak;
+
 Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
 			  void *data, size_t data_len);
 void final_note(Elf_Word *buf);
--- a/kernel/crash_core.c~kdump-append-kernel-build-id-string-to-vmcoreinfo
+++ a/kernel/crash_core.c
@@ -11,6 +11,8 @@
 #include <asm/page.h>
 #include <asm/sections.h>
 
+#include <crypto/sha.h>
+
 /* vmcoreinfo stuff */
 unsigned char *vmcoreinfo_data;
 size_t vmcoreinfo_size;
@@ -376,6 +378,53 @@ phys_addr_t __weak paddr_vmcoreinfo_note
 }
 EXPORT_SYMBOL(paddr_vmcoreinfo_note);
 
+#define NOTES_SIZE (&__stop_notes - &__start_notes)
+#define BUILD_ID_MAX SHA1_DIGEST_SIZE
+#define NT_GNU_BUILD_ID 3
+
+struct elf_note_section {
+	struct elf_note	n_hdr;
+	u8 n_data[];
+};
+
+/*
+ * Add build ID from .notes section as generated by the GNU ld(1)
+ * or LLVM lld(1) --build-id option.
+ */
+static void add_build_id_vmcoreinfo(void)
+{
+	char build_id[BUILD_ID_MAX * 2 + 1];
+	int n_remain = NOTES_SIZE;
+
+	while (n_remain >= sizeof(struct elf_note)) {
+		const struct elf_note_section *note_sec =
+			&__start_notes + NOTES_SIZE - n_remain;
+		const u32 n_namesz = note_sec->n_hdr.n_namesz;
+
+		if (note_sec->n_hdr.n_type == NT_GNU_BUILD_ID &&
+		    n_namesz != 0 &&
+		    !strcmp((char *)&note_sec->n_data[0], "GNU")) {
+			if (note_sec->n_hdr.n_descsz <= BUILD_ID_MAX) {
+				const u32 n_descsz = note_sec->n_hdr.n_descsz;
+				const u8 *s = &note_sec->n_data[n_namesz];
+
+				s = PTR_ALIGN(s, 4);
+				bin2hex(build_id, s, n_descsz);
+				build_id[2 * n_descsz] = '\0';
+				VMCOREINFO_BUILD_ID(build_id);
+				return;
+			}
+			pr_warn("Build ID is too large to include in vmcoreinfo: %u > %u\n",
+				note_sec->n_hdr.n_descsz,
+				BUILD_ID_MAX);
+			return;
+		}
+		n_remain -= sizeof(struct elf_note) +
+			ALIGN(note_sec->n_hdr.n_namesz, 4) +
+			ALIGN(note_sec->n_hdr.n_descsz, 4);
+	}
+}
+
 static int __init crash_save_vmcoreinfo_init(void)
 {
 	vmcoreinfo_data = (unsigned char *)get_zeroed_page(GFP_KERNEL);
@@ -394,6 +443,7 @@ static int __init crash_save_vmcoreinfo_
 	}
 
 	VMCOREINFO_OSRELEASE(init_uts_ns.name.release);
+	add_build_id_vmcoreinfo();
 	VMCOREINFO_PAGESIZE(PAGE_SIZE);
 
 	VMCOREINFO_SYMBOL(init_uts_ns);
_
