Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8268D64CC6
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 18:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133790; cv=none; b=XUHWMqbiu0FpIJDLv59cc4G5imPeZDtH8bY7XSTfbWENmxqbuNWBNiVamoYWgZ8vV0KP6n1IU4ZWe4MuiL03qA07+PZ5rd6iEOgb6ZFtmxgoFHqVVGSX1dA75TG+yCbhzjednq0AYAr1sPTkDJl5nnxyV4wDkqLvtYBJeBHrpNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133790; c=relaxed/simple;
	bh=cJnY5YZM24/5bkU3iGVMjuKsZsUxJzI6NfHuCfgMgL8=;
	h=Date:To:From:Subject:Message-Id; b=KGY5RzqWg0ZWMY5A3toquUT9jLYCfLrGCOF3ZZqiVgDG8M9aSwcZBLQ/JsArkIp5mgRE+WPaWFE1eC9ZylHIIwkZ0IMUoWXstKFhMm5gbcUnpisu+mK/cjDbhQSWwVkHZw2kGRk4zIQYxO8XYxdTYW5E3YWWT1mSUZoDwR1K00k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ggi6c/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ggi6c/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D9EC433C7;
	Fri, 22 Mar 2024 18:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711133790;
	bh=cJnY5YZM24/5bkU3iGVMjuKsZsUxJzI6NfHuCfgMgL8=;
	h=Date:To:From:Subject:From;
	b=0ggi6c/X/fPvpCaOjK5NCPLfHZ96WKDOI9zZbnFis/YYBp3wo1tMzLnvimpETgGrM
	 n5JcmUP2fbXm1MV0OPvvDZo0LFRLEnEwlib74vaFeMglOgpasqJQAUoN3JsRHGfovY
	 /kJJzzBtka3TPkjHtY+SGLHPxFfVihY+okfCcRHU=
Date: Fri, 22 Mar 2024 11:56:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@ZenIV.linux.org.uk,tujinjiang@huawei.com,jack@suse.cz,brauner@kernel.org,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem.patch added to mm-unstable branch
Message-Id: <20240322185630.36D9EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: break read-ahead loop if filemap_add_folio return -ENOMEM
has been added to the -mm mm-unstable branch.  Its filename is
     mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem.patch

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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/readahead: break read-ahead loop if filemap_add_folio return -ENOMEM
Date: Fri, 22 Mar 2024 17:35:54 +0800

Patch series "Fix I/O high when memory almost met memcg limit", v2.

Recently, when install package in a docker which almost reached its memory
limit, the installer has no respond severely for more than 15 minutes. 
During this period, I/O stays high(~1G/s) and influence the whole machine.
I've constructed a use case as follows:

  1. create a docker:

	$ cat test.sh
	#!/bin/bash
  
	docker rm centos7 --force

	docker create --name centos7 --memory 4G --memory-swap 6G centos:7 /usr/sbin/init
	docker start centos7
	sleep 1

	docker cp ./alloc_page centos7:/
	docker cp ./reproduce.sh centos7:/

	docker exec -it centos7 /bin/bash

  2. try reproduce the problem in docker:

	$ cat reproduce.sh
	#!/bin/bash
  
	while true; do
		flag=$(ps -ef | grep -v grep | grep alloc_page| wc -l)
		if [ "$flag" -eq 0 ]; then
			/alloc_page &
		fi

		sleep 30

		start_time=$(date +%s)
		yum install -y expect > /dev/null 2>&1

		end_time=$(date +%s)

		elapsed_time=$((end_time - start_time))

		echo "$elapsed_time seconds"
		yum remove -y expect > /dev/null 2>&1
	done

	$ cat alloc_page.c:
	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <string.h>

	#define SIZE 1*1024*1024 //1M

	int main()
	{
		void *addr = NULL;
		int i;

		for (i = 0; i < 1024 * 6 - 50;i++) {
			addr = (void *)malloc(SIZE);
			if (!addr)
				return -1;

			memset(addr, 0, SIZE);
		}

		sleep(99999);
		return 0;
	}


We found that this problem is caused by a lot ot meaningless read-ahead. 
Since the docker is almost met memory limit, the page will be reclaimed
immediately after read-ahead and will read-ahead again immediately.  The
program is executed slowly and waste a lot of I/O resource.

These two patch aim to break the read-ahead in above scenario.

[1] https://lore.kernel.org/linux-mm/c2f4a2fa-3bde-72ce-66f5-db81a373fdbc@huawei.com/T/
[2] https://lore.kernel.org/all/20240201100835.1626685-1-liushixin2@huawei.com/
[3] https://lore.kernel.org/all/20240201173130.frpaqpy7iyzias5j@quack3/


This patch (of 2):

When filemap_add_folio() return -ENOMEM, break read-ahead loop like what
filemap_alloc_folio() does.

Link: https://lkml.kernel.org/r/20240322093555.226789-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20240322093555.226789-2-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/readahead.c~mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem
+++ a/mm/readahead.c
@@ -228,6 +228,7 @@ void page_cache_ra_unbounded(struct read
 	 */
 	for (i = 0; i < nr_to_read; i++) {
 		struct folio *folio = xa_load(&mapping->i_pages, index + i);
+		int ret;
 
 		if (folio && !xa_is_value(folio)) {
 			/*
@@ -247,9 +248,12 @@ void page_cache_ra_unbounded(struct read
 		folio = filemap_alloc_folio(gfp_mask, 0);
 		if (!folio)
 			break;
-		if (filemap_add_folio(mapping, folio, index + i,
-					gfp_mask) < 0) {
+
+		ret = filemap_add_folio(mapping, folio, index + i, gfp_mask);
+		if (ret < 0) {
 			folio_put(folio);
+			if (ret == -ENOMEM)
+				break;
 			read_pages(ractl);
 			ractl->_index++;
 			i = ractl->_index + ractl->_nr_pages - index - 1;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem.patch
mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch

