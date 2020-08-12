Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66BFC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA322206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195890;
	bh=WTrrFAmC/PkbTaKqNlsgJAb+46/7jme6qulexayAfOE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=UCZfvugby//DPgCxookFIPBxubyZluLDB+A3POWEanJyr9SBlrOP/a4KjBkk0JUea
	 wDh8CD7iuz2y+opQJ8uJdcvQ4I4TzdmVtnaod+oIGKIlWg40CIoHS5t3uUr4/CCzPO
	 MAaRfiPlLFdsfalM5kmsxzCxN4odgUbxa5RzxejI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgHLBba (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBba (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DAE92076C;
        Wed, 12 Aug 2020 01:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195889;
        bh=WTrrFAmC/PkbTaKqNlsgJAb+46/7jme6qulexayAfOE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=x38T13cWqblY0MtpLce2zWo0c07/ywDlWyUg9FSH72LUbTW1TEYg4N8svvlRLsw3k
         e72eFIlL4WZLtN9OoUdcxvdxF2s4VaqJU5V1MC6ZA7H0l0xQEZN21spFJtMrP5b4w7
         H3JeZpygKWiDA64TeUZASDWGLtpmqyjdJRpi8e0Y=
Date:   Tue, 11 Aug 2020 18:31:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, laoar.shao@gmail.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org
Subject:  [patch 023/165] doc, mm: clarify /proc/<pid>/oom_score
 value range
Message-ID: <20200812013128.TFhR9DDig%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: doc, mm: clarify /proc/<pid>/oom_score value range

The exported value includes oom_score_adj so the range is no [0, 1000] as
described in the previous section but rather [0, 2000].  Mention that fact
explicitly.

Link: http://lkml.kernel.org/r/20200709062603.18480-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/filesystems/proc.rst~doc-mm-clarify-proc-pid-oom_score-value-range
+++ a/Documentation/filesystems/proc.rst
@@ -1676,6 +1676,9 @@ This file can be used to check the curre
 any given <pid>. Use it together with /proc/<pid>/oom_score_adj to tune which
 process should be killed in an out-of-memory situation.
 
+Please note that the exported value includes oom_score_adj so it is
+effectively in range [0,2000].
+
 
 3.3  /proc/<pid>/io - Display the IO accounting fields
 -------------------------------------------------------
_
