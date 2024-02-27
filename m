Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EA63DB86
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059384; cv=none; b=jOXzmckRU5pqLwLcOmNT5boKH5mS5VqpMtnQYULv48Lq705sfpdsFEdgnf2DvdX8Pu7YwP5My3CMyT+NUBOWcOuYvYjXUJwzjXvp6tcYIpgrlDEKTcaInRsFcrdxkjT8KsTcE83i2IKqIXtZCCPZZg33rz0g1mhQRIgzzDHRDI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059384; c=relaxed/simple;
	bh=D0wHbql/02mVywHGZEvBA8uGaD4hsDoRKp5IamiQ6dM=;
	h=Date:To:From:Subject:Message-Id; b=QZ3ffiE20NL9/HdNc3GRzfXGTUc6kSvycWGsMjKp73bOoqt1ByEdnpVaU8U6VHKYA+SJ+HH/9yQJu8fbdwlexWABbfpIfcEFzn/hjCK4c7d9u79yoqK4GNEusApySTtOERiuIbhRAeku5fsmZTjGYdbQTz5P+M2ds19bgVHxLtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rc6t+EQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rc6t+EQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E77C433F1;
	Tue, 27 Feb 2024 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059383;
	bh=D0wHbql/02mVywHGZEvBA8uGaD4hsDoRKp5IamiQ6dM=;
	h=Date:To:From:Subject:From;
	b=Rc6t+EQjfTFRc1y1pYH31QcdS7FpRnHM1uVS3Fn7pW75jjzR4pT356TO7SluXtkrx
	 ai6kPKE6+FfzSdJgZykdTTYUTTIqko33DaVsOprqEjuA0qfcN1al6Z6DG+7ZPk2KS0
	 QtMhsI+ZDjrpVJD9kh1c/ld0sfsTIthvVS11dcKI=
Date: Tue, 27 Feb 2024 10:43:03 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,lijiang@redhat.com,k-hagio-ab@nec.com,dyoung@redhat.com,bhe@redhat.com,shijie@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_core-export-vmemmap-when-config_sparsemem_vmemmap-is-enabled.patch added to mm-nonmm-unstable branch
Message-Id: <20240227184303.C0E77C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_core: export vmemmap when CONFIG_SPARSEMEM_VMEMMAP is enabled
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_core-export-vmemmap-when-config_sparsemem_vmemmap-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_core-export-vmemmap-when-config_sparsemem_vmemmap-is-enabled.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Huang Shijie <shijie@os.amperecomputing.com>
Subject: crash_core: export vmemmap when CONFIG_SPARSEMEM_VMEMMAP is enabled
Date: Tue, 27 Feb 2024 09:49:52 +0800

In memory_model.h, if CONFIG_SPARSEMEM_VMEMMAP is configed, kernel will
use vmemmap to do the __pfn_to_page/page_to_pfn, and kernel will not use
the "classic sparse" to do the __pfn_to_page/page_to_pfn.

So export the vmemmap when CONFIG_SPARSEMEM_VMEMMAP is configed.  This
makes the user applications (crash, etc) get faster
pfn_to_page/page_to_pfn operations too.

Link: https://lkml.kernel.org/r/20240227014952.3184-1-shijie@os.amperecomputing.com
Signed-off-by: Huang Shijie <shijie@os.amperecomputing.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Lianbo Jiang <lijiang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/vmcore_info.c~crash_core-export-vmemmap-when-config_sparsemem_vmemmap-is-enabled
+++ a/kernel/vmcore_info.c
@@ -152,6 +152,9 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_SYMBOL(mem_map);
 	VMCOREINFO_SYMBOL(contig_page_data);
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	VMCOREINFO_SYMBOL_ARRAY(vmemmap);
+#endif
 #ifdef CONFIG_SPARSEMEM
 	VMCOREINFO_SYMBOL_ARRAY(mem_section);
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
_

Patches currently in -mm which might be from shijie@os.amperecomputing.com are

crash_core-export-vmemmap-when-config_sparsemem_vmemmap-is-enabled.patch

