Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EECC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8A320829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196042;
	bh=8pBjG1s/DzXnbVwizeDhUiEgCJ65c30tkACbLPAMA0Y=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=EBUFRQSQ3HneA8Dz6gJF0jqejrechR9ijws3e7l3C9pIt94ypWC9dHzdhO0vSyoRi
	 v6TiTcXb8HBATwoxajqRXVgqotg/GrR6i2AvsbvM6nccnqD4C6fNdHc+Q4CJgAKj+j
	 +Dw8FablplM426B+sVXvoBN25M6moMewF8NRT4ZM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHLBeC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgHLBeC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4252080C;
        Wed, 12 Aug 2020 01:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196041;
        bh=8pBjG1s/DzXnbVwizeDhUiEgCJ65c30tkACbLPAMA0Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y98kvIUWe2UAP0l4FF97uclUQRCdwrOvfcYW6pnhS5BzJEKsJWBnMvOxl1cocvXnn
         GQje+5PhwA5Sulk4zl5t31JqWcJ1JauHEGxjDrwknhcLIS9mJv3kuUR8uLJXoogPdy
         L6UOsGOw8vZfayc9u/v5D8WIDtE7XXLYaDoz3O1A=
Date:   Tue, 11 Aug 2020 18:34:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 071/165] include/linux/exportfs.h: drop duplicated
 word in a comment
Message-ID: <20200812013400.CYLN8jT6R%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/exportfs.h: drop duplicated word in a comment

Drop the doubled word "a" in a comment.

Link: http://lkml.kernel.org/r/c61b707a-8fd8-5b1b-aab0-679122881543@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/exportfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/exportfs.h~linux-exportfsh-drop-duplicated-word-in-a-comment
+++ a/include/linux/exportfs.h
@@ -178,7 +178,7 @@ struct fid {
  * get_name:
  *    @get_name should find a name for the given @child in the given @parent
  *    directory.  The name should be stored in the @name (with the
- *    understanding that it is already pointing to a a %NAME_MAX+1 sized
+ *    understanding that it is already pointing to a %NAME_MAX+1 sized
  *    buffer.   get_name() should return %0 on success, a negative error code
  *    or error.  @get_name will be called without @parent->i_mutex held.
  *
_
