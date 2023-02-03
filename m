Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C17DC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 10:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjBCKzA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 05:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbjBCKyw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 05:54:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9329C712EB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 02:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675421647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZdNVQnIEtu86bz3MRrpeYvpbz+dF7Lru5DMYQYbwxM=;
        b=XhB8kpYQbeOfmMmvDissQoc+NBwjnxu6ZSHXQAttYjs9AOcgQkKlQt7BZY5M7pHg022nQn
        VVrkksvZr9lTt3xwicsMJO7bkk994Qi7jlVGsqZaWXz6YCXyh3eiIkS9kBO+JuLcyn9qPt
        4CsyGaSjLHVI7qVCeAxHGg/UDbD6eTA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-7FU3jfKaOzm31odbYWcpdA-1; Fri, 03 Feb 2023 05:54:04 -0500
X-MC-Unique: 7FU3jfKaOzm31odbYWcpdA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F248785A588;
        Fri,  3 Feb 2023 10:54:03 +0000 (UTC)
Received: from pasta.redhat.com (ovpn-192-126.brq.redhat.com [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC195C15BA0;
        Fri,  3 Feb 2023 10:54:02 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        mm-commits@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [merged mm-stable] gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch removed from -mm tree
Date:   Fri,  3 Feb 2023 11:54:01 +0100
Message-Id: <20230203105401.3362277-1-agruenba@redhat.com>
In-Reply-To: <20230203063724.26745C4339B@smtp.kernel.org>
References: <20230203063724.26745C4339B@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On Fri, Feb 3, 2023 at 7:37 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> The quilt patch titled
>      Subject: gfs2: convert gfs2_write_cache_jdata() to use filemap_get_folios_tag()
> has been removed from the -mm tree.  Its filename was
>      gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

note that there now is a conflict between the following commit in v6.2-rc6:

95ecbd0f162f ("Revert "gfs2: stop using generic_writepages in gfs2_ail1_start_one"")

and this commit in mm-stable:

d585bdbeb79a ("fs: convert writepage_t callback to pass a folio")

Trivial resolution below.

Thanks,
Andreas

---
 fs/gfs2/log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 25fd21a9dec8..807daaeb4153 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -80,11 +80,11 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
 	brelse(bd->bd_bh);
 }
 
-static int __gfs2_writepage(struct page *page, struct writeback_control *wbc,
-		       void *data)
+static int __gfs2_writepage(struct folio *folio, struct writeback_control *wbc,
+			    void *data)
 {
 	struct address_space *mapping = data;
-	int ret = mapping->a_ops->writepage(page, wbc);
+	int ret = mapping->a_ops->writepage(&folio->page, wbc);
 	mapping_set_error(mapping, ret);
 	return ret;
 }
-- 
2.39.0

