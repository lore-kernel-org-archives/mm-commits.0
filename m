Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373C711702
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600581; cv=none; b=cRjlIZdy0u+PtBsX5Low/kyacaJ4p6jVEMe3z3iLLUctYI4iRGnhi3KXmt3MD9A9zUhMs3FjVeZIswd1aGBVKDZ2VKNC9kmhc03ZJSSV+J6u90i8q9jhVGegf6oE02G0iZ4FMXDWjVWdqDWxm9C9E3eJUEiZC1NxdNwWeitXSWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600581; c=relaxed/simple;
	bh=wG4sDREmIoyBpW9hDBO7cXbHtFOIjFDdCM8UM7dvnX8=;
	h=Date:To:From:Subject:Message-Id; b=KLJqBy5eoPlSfb9Y/yXwgGlKSCzFNANc7T1LnN1T1DeaCaSBak3Fr2rqsMxrOfywLyR4HRLY2QAxTvDRzHi/nrMIcXr1fvvYNIenqXrhR9vrENkZxT04Hb2I8ROeuWGUUKjxQyv7Bf8ybwsA4M5yeDqAt+YKtpDRmnvBrX9dA5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fq+S8kyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fq+S8kyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABCBC43390;
	Tue,  5 Mar 2024 01:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600581;
	bh=wG4sDREmIoyBpW9hDBO7cXbHtFOIjFDdCM8UM7dvnX8=;
	h=Date:To:From:Subject:From;
	b=Fq+S8kyzOX+WeRM68K6yRKJhBWy9qatmFbRcitWXBlW7xaDR8Aj92rnV/h7iapHUU
	 Me/AhodFBkwl2G4drKMbHBRzFOy+3JfWb7Ep3Rv+MEm1vjgTz/TcB2tPlIHvMOqr/D
	 qklsso9MegDf15xw1alHuqY/WCDsYTO23prpUtlY=
Date: Mon, 04 Mar 2024 17:03:00 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,lijiang@redhat.com,k-hagio-ab@nec.com,dyoung@redhat.com,bhe@redhat.com,shijie@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] crash_core-export-vmemmap-when-config_sparsemem_vmemmap-is-enabled.patch removed from -mm tree
Message-Id: <20240305010301.0ABCBC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_core: export vmemmap when CONFIG_SPARSEMEM_VMEMMAP is enabled
has been removed from the -mm tree.  Its filename was
     crash_core-export-vmemmap-when-config_sparsemem_vmemmap-is-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


