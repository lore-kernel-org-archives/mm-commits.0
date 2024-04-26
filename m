Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2D17D412
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103978; cv=none; b=tqirA5/wBrCJvUdC1vZnd0AhfLFKFyn+9FFfZLC+jlX4AYQHsLhSvil59eeBPFxPzp0Dph8JnvKyNVTxbt+TInJvhO/OediVWu1kQMbcmAUwhxfRXVA9gF/rsqITLRKxmt9LIIWJnFoTbPZ1k6r1Wz4t2EAQqiirgaIWQy5Qgts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103978; c=relaxed/simple;
	bh=yaOkW+uCk7CJkpvgU4bSeTobQnNyx5Cvuvwy8lIt8Ts=;
	h=Date:To:From:Subject:Message-Id; b=f/rxL2JgsmPymmN6v2/f1p8RJgzZDzZbRXxjDGwBklK1+7HUflEwg6IyDEuwvehtJvShJL9TTJ/xsx2Oqscw/WIwVGjcYJPsC7CUwR+Gkspgdx0zv/gNXHewainNbXVIrsCJWXfBCZFmlfheELR+clHnMHDKFgkfPO2F//luirg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RD4VqRlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RD4VqRlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A564CC116B1;
	Fri, 26 Apr 2024 03:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103978;
	bh=yaOkW+uCk7CJkpvgU4bSeTobQnNyx5Cvuvwy8lIt8Ts=;
	h=Date:To:From:Subject:From;
	b=RD4VqRlc5cF99e31MQ6WmCIzsDpjuzI+HXm2t7fzYNabB79t2zspDrLvr38O8EHcJ
	 giO3M2b13D6JEcprz+y7ilAkK/JQoCUg0Ca55+WLXXkSTU31zHq0qMKm+zePYyYNVE
	 iZSC5Og0mjDkyMvL84cfUbQWMX6BUQa3sBfDaIZ8=
Date: Thu, 25 Apr 2024 20:59:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@ZenIV.linux.org.uk,tujinjiang@huawei.com,jack@suse.cz,brauner@kernel.org,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem.patch removed from -mm tree
Message-Id: <20240426035938.A564CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: break read-ahead loop if filemap_add_folio return -ENOMEM
has been removed from the -mm tree.  Its filename was
     mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


