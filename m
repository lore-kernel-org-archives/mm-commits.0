Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0441021E3BC
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033319; cv=none; b=qX76WnNbmtBaBzekFJHxWA23/DE3ZjezMfYBTUs59f/UwB7NULTF3HbcbYLUH52/WDaKXzH6MRYxJMMaC4BeRRcxfJYjLTC1N6H50yYh5Fta7V7+LS+DirOfC9Ht6q4MxNL+Up8D2kXhAAtCtoZdgh5M9fM9ep6NAImOWLsKxJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033319; c=relaxed/simple;
	bh=LhPTaanng0nuYvmeCWbDgYhcnvgnZIRVBfvxIn9v1oM=;
	h=Date:To:From:Subject:Message-Id; b=WSA1qUMo3OGzJpmw+FoOiGXk8bzKqYNiJihKOxNuVtOyzGxZFNrovrnHihDc1YsER2mv1K3UhaDlQS/ydi7sy9vMYQkwNrJFzJK4588eNRo1KImIJAfu+HeGQasyUzi0uu54yLSPh10jeCOaAlpE+kUjLyTJAelPzF9TG75Fnl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a9rRNfIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a9rRNfIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3E1C4CEC6;
	Tue, 15 Oct 2024 23:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729033318;
	bh=LhPTaanng0nuYvmeCWbDgYhcnvgnZIRVBfvxIn9v1oM=;
	h=Date:To:From:Subject:From;
	b=a9rRNfIfAiKG91OKUzyI8WLbqemtV3okBGTXUhyJHumoqTSXAP2ABmD3Ojc0z6h52
	 IX5u3JCKTkWWBOdcU7KxqAUgoLreGGTDPZZjlQLHp1jRpz6RdmZkB5Sws6YipUfb7P
	 nkqK0qd+2J00rl+FqAJLmALHrD7LjYuF5tObQvVs=
Date: Tue, 15 Oct 2024 16:01:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootmem-add-bootmem_type-stub-function-fix-2.patch added to mm-unstable branch
Message-Id: <20241015230158.6E3E1C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootmem: add bootmem_type stub function
has been added to the -mm mm-unstable branch.  Its filename is
     bootmem-add-bootmem_type-stub-function-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootmem-add-bootmem_type-stub-function-fix-2.patch

This patch will later appear in the mm-unstable branch at
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

bootmem-add-bootmem_type-stub-function-fix-2.patch

