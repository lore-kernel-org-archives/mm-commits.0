Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C5EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 17 Sep 2021 18:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0EE61164
	for <mm-commits@archiver.kernel.org>; Fri, 17 Sep 2021 18:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245224AbhIQSQO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Sep 2021 14:16:14 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34558 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbhIQSQO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Sep 2021 14:16:14 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 358B11FF74;
        Fri, 17 Sep 2021 18:14:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BCC0F13C4E;
        Fri, 17 Sep 2021 18:14:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +xWPIxnbRGFffAAAMHmgww
        (envelope-from <dave@stgolabs.net>); Fri, 17 Sep 2021 18:14:49 +0000
Date:   Fri, 17 Sep 2021 11:14:42 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     akpm@linux-foundation.org
Cc:     ebiederm@xmission.com, manfred@colorfullife.com,
        mclapinski@google.com, mm-commits@vger.kernel.org
Subject: Re:
 +ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch
 added to -mm tree
Message-ID: <20210917181442.x6fgmpwzapkc2odc@offworld>
References: <20210916175104.Fx0YqSM5k%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210916175104.Fx0YqSM5k%akpm@linux-foundation.org>
User-Agent: NeoMutt/20201120
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 16 Sep 2021, akpm@linux-foundation.org wrote:

>Subject: ipc: check checkpoint_restore_ns_capable() to modify C/R proc files
>
>This commit removes the requirement to be root to modify sem_next_id,
>msg_next_id and shm_next_id and checks checkpoint_restore_ns_capable
>instead.

After reading 124ea650d3072b005457faed69909221c2905a1f this makes sense
to me.

>
>Since those files are specific to the IPC namespace, there is no reason
>they should require root privileges.  This is similar to ns_last_pid,
>which also only checks checkpoint_restore_ns_capable.
>
>Link: https://lkml.kernel.org/r/20210916163717.3179496-1-mclapinski@google.com
>Signed-off-by: Michal Clapinski <mclapinski@google.com>
>Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>Cc: Davidlohr Bueso <dave@stgolabs.net>
>Cc: Manfred Spraul <manfred@colorfullife.com>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
