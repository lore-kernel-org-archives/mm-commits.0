Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD69F23B0;
	Fri, 27 Sep 2024 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727459294; cv=none; b=GRA5Sj36U2nDBY+LEOqd7RKafClfM/cP1vku14x/Dbf2hNAMMGXamoTwB98zWF8bp+z0okhiucq0S+7cLmMlW4lN9jfM1EjGpJEDxh64p4M0jJv5BKsHHz7mHFyo82uEKW7hyYVN+le95kEM8gvVClZcFAef9Tl5sQB2wl0yd5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727459294; c=relaxed/simple;
	bh=pNw3zKwdMtL7NfMREQ+LKmkz8t+rFvz3xBkh/xMJNnY=;
	h=Date:To:From:Subject:Message-Id; b=uSRUr+AOrZ0D6rlrxqZKAjBTstIHNw6luN05EDjgkZP7QRVpuU1tKVZZHg4hFqKlwf2pV6kTqWngJHvtukLMrmCzByZVkxSkDqJJjZyUNx75bbF4ArqU8G9jFn2s20lQV99OzqMZrxkh48zghc2wTIOwl0Ndyti2Ec0jRkIKaUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n5e0xW9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n5e0xW9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED5DC4CEC7;
	Fri, 27 Sep 2024 17:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727459293;
	bh=pNw3zKwdMtL7NfMREQ+LKmkz8t+rFvz3xBkh/xMJNnY=;
	h=Date:To:From:Subject:From;
	b=n5e0xW9Yhn5pPWoHgxjviSrUmBUZopNzJMKVba3a69P4lZ0bz4q8xMmfoVa83O6My
	 YkXFT3ao+pB7VQLCn4Y1OKpAH2n92YxHeHvZPL3zjUb/KjaZD9Cla0AHEsxVSL3qPM
	 UDL4aLSHYMI5vKASQn9FsBOlRFlHnk5s6m95H9Is=
Date: Fri, 27 Sep 2024 10:48:12 -0700
To: mm-commits@vger.kernel.org,zhaojianxiong.zjx@alibaba-inc.com,stable@vger.kernel.org,joao.m.martins@oracle.com,dan.j.williams@intel.com,llfl@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + device-dax-correct-pgoff-align-in-dax_set_mapping.patch added to mm-hotfixes-unstable branch
Message-Id: <20240927174813.6ED5DC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: device-dax: correct pgoff align in dax_set_mapping()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     device-dax-correct-pgoff-align-in-dax_set_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/device-dax-correct-pgoff-align-in-dax_set_mapping.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Kun(llfl)" <llfl@linux.alibaba.com>
Subject: device-dax: correct pgoff align in dax_set_mapping()
Date: Fri, 27 Sep 2024 15:45:09 +0800

pgoff should be aligned using ALIGN_DOWN() instead of ALIGN().  Otherwise,
vmf->address not aligned to fault_size will be aligned to the next
alignment, that can result in memory failure getting the wrong address.

Link: https://lkml.kernel.org/r/23c02a03e8d666fef11bbe13e85c69c8b4ca0624.1727421694.git.llfl@linux.alibaba.com
Fixes: b9b5777f09be ("device-dax: use ALIGN() for determining pgoff")
Signed-off-by: Kun(llfl) <llfl@linux.alibaba.com>
Tested-by: JianXiong Zhao <zhaojianxiong.zjx@alibaba-inc.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/device.c~device-dax-correct-pgoff-align-in-dax_set_mapping
+++ a/drivers/dax/device.c
@@ -86,7 +86,7 @@ static void dax_set_mapping(struct vm_fa
 		nr_pages = 1;
 
 	pgoff = linear_page_index(vmf->vma,
-			ALIGN(vmf->address, fault_size));
+			ALIGN_DOWN(vmf->address, fault_size));
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
_

Patches currently in -mm which might be from llfl@linux.alibaba.com are

device-dax-correct-pgoff-align-in-dax_set_mapping.patch

