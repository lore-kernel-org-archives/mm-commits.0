Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F894192B73
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731018992; cv=none; b=eJrFgn0V2RlqtivfkNXg6JKrwU3sREaRDOklQOg2ix47qTsnHgI8g6U6cvZrdJYMNmYZcds57rMcwAsj5mjQQxHTKvsRMO2CIGC7+WfCqU0uXzMayYMOFNUeM3gt/Ftn5t42nNHZPB98r9qY+uhhi5auR3hx9p0IhA5v/L5O7ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731018992; c=relaxed/simple;
	bh=u7iSfx/StaWNBdcbPXNe1IkuLuexKavF9LSLGN/47J0=;
	h=Date:To:From:Subject:Message-Id; b=agkiAKDlTFqPjRM+OCe90xZye26WQojwnZ4Y5JGdeleNX48oW9nqTG1EFkqWvKKT+eQ9nAM+r018HTvzo/O+bYCrIDRpzGP3HbgQTSlfjUGFoVku7nMtk1vwArFZiu15vPYKFdYJScBA2H0700sApDEIyhIUs7mU2fhcIB10bq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jLmyRarM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jLmyRarM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D27CC4CECC;
	Thu,  7 Nov 2024 22:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731018991;
	bh=u7iSfx/StaWNBdcbPXNe1IkuLuexKavF9LSLGN/47J0=;
	h=Date:To:From:Subject:From;
	b=jLmyRarMyO9ifI0Y0pY9NeQXoVLf7nEm1LF+weOTAn5ojkkhqTEP6QH+2ScL6fcSr
	 WMX6ijEu5MbZYfbJGUrXNSaz0uFa3PRClICojKprjtkcjDI5HjyCFdl0UTPpzTeDcR
	 stqiwv1/mGzdN/qvpK6oELSxTBbCvZlRFJowQo/k=
Date: Thu, 07 Nov 2024 14:36:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] bootmem-add-bootmem_type-stub-function-fix-2.patch removed from -mm tree
Message-Id: <20241107223631.9D27CC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootmem: add bootmem_type stub function
has been removed from the -mm tree.  Its filename was
     bootmem-add-bootmem_type-stub-function-fix-2.patch

This patch was dropped because it was folded into bootmem-stop-using-page-index.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: bootmem: add bootmem_type stub function
Date: Tue, 15 Oct 2024 14:36:06 +0000

When CONFIG_HAVE_BOOTMEM_INFO_NODE is disabled, the bootmem_type() and
bootmem_info() functions are not defined:

mm/sparse.c: In function 'free_map_bootmem':
mm/sparse.c:730:24: error: implicit declaration of function 'bootmem_type' [-Wimplicit-function-declaration]
  730 |                 type = bootmem_type(page);
      |                        ^~~~~~~~~~~~

mm/sparse.c: In function 'free_map_bootmem':
mm/sparse.c:735:39: error: implicit declaration of function 'bootmem_info'; did you mean 'bootmem_type'? [-Wimplicit-function-declaration]

Add trivial stub functions to make it build.

Link: https://lkml.kernel.org/r/20241015143802.577613-1-arnd@kernel.org
Fixes: 43d552a255a6 ("bootmem: stop using page->index")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem_info.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/linux/bootmem_info.h~bootmem-add-bootmem_type-stub-function-fix-2
+++ a/include/linux/bootmem_info.h
@@ -62,6 +62,16 @@ static inline void put_page_bootmem(stru
 {
 }
 
+static inline enum bootmem_type bootmem_type(const struct page *page)
+{
+	return SECTION_INFO;
+}
+
+static inline unsigned long bootmem_info(const struct page *page)
+{
+	return 0;
+}
+
 static inline void get_page_bootmem(unsigned long info, struct page *page,
 				    enum bootmem_type type)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

bootmem-stop-using-page-index.patch
kasan-migrate-copy_user_test-to-kunit-fix.patch

