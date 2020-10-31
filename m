Return-Path: <SRS0=UFsa=EG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B50C388F7
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BDE9206ED
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604173654;
	bh=K7I7lXMEGaAu23kTVyGq5tFDHR9lE/0F5Qed3vL765w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=eu4pJid/h26gcuRR9InKzPPEsO4fT0Ac/cv4+rGeq13Q8D6xNRlvGdxGaDHyFrhV3
	 fHT5nFUbW46h7A2wQ/7kleY/cJ2m3GRXepJ1y0ppKiQLwONOrSDWXma7QZpyYWoaJf
	 J+1G/JF7XA3zDxXszYhFAXOxtafgXuq1uByATxw0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgJaTrd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 31 Oct 2020 15:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbgJaTrd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 31 Oct 2020 15:47:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D867F206E3;
        Sat, 31 Oct 2020 19:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604173653;
        bh=K7I7lXMEGaAu23kTVyGq5tFDHR9lE/0F5Qed3vL765w=;
        h=Date:From:To:Subject:From;
        b=eg989FLpeYZZRKpEDE0Q1DJt/LrKpUXMF9w0CFUqMMBZkUdqcyVr5blXOBZPhU5TI
         fwpWovZv/ECtWmkiE1WzjnoCwZ/nw2/jVZarg5oz6x6D7Qn0WEEf3BW87+Mpo1X+RQ
         PQeJrusfKZz2GxaEmfh/SEO6p/ZFjA4ibOP19OOU=
Date:   Sat, 31 Oct 2020 12:47:32 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com, glider@google.com,
        keescook@chromium.org, mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-page=5Falloc-do-not-rely-on-the-order-of-page=5Fpoison?=
 =?US-ASCII?Q?-and-init=5Fon=5Falloc-free-parameters-fix.patch?= removed
 from -mm tree
Message-ID: <20201031194732.q7LQPIAYR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix.patch

This patch was dropped because it was folded into mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix

fix init_mem_debugging() definition, per Mike

Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix
+++ a/mm/page_alloc.c
@@ -758,7 +758,7 @@ static inline void clear_page_guard(stru
  * order of appearance. So we need to first gather the full picture of what was
  * enabled, and then make decisions.
  */
-void init_mem_debugging()
+void init_mem_debugging(void)
 {
 	if (_init_on_alloc_enabled_early) {
 		if (page_poisoning_enabled()) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch
mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix.patch
mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

