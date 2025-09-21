Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74FD2C08A2
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489982; cv=none; b=UoLrHsltFjvVm695rGLl16KQIji423fmB94RMVSTIbSwa88jrstFcbXje2oSKG4h2H8B0L4mVxlyjUXHA87WwRXzwznhG9wKpRfPdgdMh0nUWg9GX0JZTXJYipoeEFZ+iW6+s2LFF/Gxnom4Qv3y/d8sND3GGPCkIO6H3BO/tzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489982; c=relaxed/simple;
	bh=gm9dGL2KbSET8Cvrrknd6irIjJPiE1gJYtroO7ShBXE=;
	h=Date:To:From:Subject:Message-Id; b=F7Elc39jhlOJEZPtrh0J/wgVeId6sQTpW9ZLqeJifcwQZM0c95PRTVJ3UIKA5p8a5u7XKOuFHk7AnLa/KTA5LWKkkUiJQXp911KsWd1jLM9bzfPgYJBa8NZ2gCw1zRTcplfATuZb3444Yj62G7NkCgXwCvABZotufH+6G6AlKIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FMgtHBej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FMgtHBej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5214EC4CEE7;
	Sun, 21 Sep 2025 21:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489982;
	bh=gm9dGL2KbSET8Cvrrknd6irIjJPiE1gJYtroO7ShBXE=;
	h=Date:To:From:Subject:From;
	b=FMgtHBejGclxKSrNpIcOwNhAbK6UnEIVk698kMbwRKmpshAzXdDpZw1Jm8cQK/dQo
	 pD+0s9R8HC/cdKlsDjBTeAXAwxel/iLE4AK1jUDpecsx2pYfIg20Omfgskg3/2HjzM
	 NLfDdfFa3HDZOs1AXCOqaUsxMJLRr0SrFesXE2rE=
Date: Sun, 21 Sep 2025 14:26:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-use-release_pages-in-the-cleanup-path.patch removed from -mm tree
Message-Id: <20250921212622.5214EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: use release_pages() in the cleanup path
has been removed from the -mm tree.  Its filename was
     alloc_tag-use-release_pages-in-the-cleanup-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: use release_pages() in the cleanup path
Date: Mon, 15 Sep 2025 14:27:54 -0700

Patch series "Minor fixes for memory allocation profiling", v2.

Over the last couple months I gathered a few reports of minor issues in
memory allocation profiling which are addressed in this patchset.


This patch (of 2):

When bulk-freeing an array of pages use release_pages() instead of freeing
them page-by-page.

Link: https://lkml.kernel.org/r/20250915212756.3998938-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250915212756.3998938-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Cc: David Wang <00107082@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-use-release_pages-in-the-cleanup-path
+++ a/lib/alloc_tag.c
@@ -438,9 +438,10 @@ static int vm_module_tags_populate(void)
 		if (nr < more_pages ||
 		    vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHIFT), PAGE_KERNEL,
 				     next_page, PAGE_SHIFT) < 0) {
+			release_pages_arg arg = { .pages = next_page };
+
 			/* Clean up and error out */
-			for (int i = 0; i < nr; i++)
-				__free_page(next_page[i]);
+			release_pages(arg, nr);
 			return -ENOMEM;
 		}
 
@@ -682,11 +683,10 @@ static int __init alloc_mod_tags_mem(voi
 
 static void __init free_mod_tags_mem(void)
 {
-	int i;
+	release_pages_arg arg = { .pages = vm_module_tags->pages };
 
 	module_tags.start_addr = 0;
-	for (i = 0; i < vm_module_tags->nr_pages; i++)
-		__free_page(vm_module_tags->pages[i]);
+	release_pages(arg, vm_module_tags->nr_pages);
 	kfree(vm_module_tags->pages);
 	free_vm_area(vm_module_tags);
 }
_

Patches currently in -mm which might be from surenb@google.com are


