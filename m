Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D857C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 04:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiLLETS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 23:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLLETR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 23:19:17 -0500
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C534B1D6
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 20:19:15 -0800 (PST)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 1C4FA261A44;
        Mon, 12 Dec 2022 04:19:15 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 80D5D261AB9;
        Mon, 12 Dec 2022 04:19:14 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1670818754; a=rsa-sha256;
        cv=none;
        b=lEqrNMbrE8sCtRy9fmoTZVZb9KSi6eLKyWuR6uqenNJFrZjP0rEzYGAKedICEKPppmZX3T
        PAWU+BOV9iDXtnCRyeR9fWVi8pq78A8W//NVA+0SvCZs80tynNSdPkiVSwizQt3rpF1ksF
        BlOkdr9aji4jjphQ0lDAmgmysWA5wW2P0j533f8qMBiFR5scqkmZoajtfBZAig1qzPwJZl
        Ssw8h+0r4z+ReDBVwW7X7BImshUTKJ8FenHGtZWS8KYlw7jgbBNplgJbP1UfjIMzpUoDlg
        fTW+Q8rPulg+piLaSpbdyqDDJoyTRxswle3OIYpSbsvCp/q/aPAOKW0GJ/yw2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1670818754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=VxeXYvWU04CSlYIlO97fNq2cBSrtJPx2DqNboUuPd9g=;
        b=CbuLfEUksttQr3LLhJ7ZwyES0u6xTcDWGTl5g9D5jBHM3ui5Josr0oV4WnGCAhFPT2/6K7
        QltK8uR/vroM0XqrnO/E6skwqXnZtpIx5g+bpAH9q3NljGQKbYlLZ+8UsS6px6CH9kUOzZ
        Tr1Vu/V4UfFH6IDRTSWAPw2cbZuDwemUhEokky4qcb9sShxxBvjXto/0ijsKJ1qH4up77T
        a8mrxmW6OMad4337c+zrecaLW2CBKmiGzzzW83ltI/3CZgLfAX3kNje5TzoJTvhnjGLXkh
        HKQh0DjX0n1jfddv5M/lUhhmb2YoYWmHuVsdrzOo2KTr4UQ2KltKHTgvxTyMFw==
ARC-Authentication-Results: i=1;
        rspamd-d48c5ddb-drv55;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Spot-Company: 52b35a1f41767db3_1670818754875_1646165757
X-MC-Loop-Signature: 1670818754875:1975398375
X-MC-Ingress-Time: 1670818754875
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.109.138.16 (trex/6.7.1);
        Mon, 12 Dec 2022 04:19:14 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4NVpKs2Y94z24;
        Sun, 11 Dec 2022 20:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1670818754;
        bh=VxeXYvWU04CSlYIlO97fNq2cBSrtJPx2DqNboUuPd9g=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=QRPWeBLd9oZY2oUxf94PJCpH3GJVFZmA2/KEYh114A7bn444H9jjJ36TbAjisW0Cz
         pxSKQh+S23SWX9UiMp7vkb8QY0hRBvs8cFC0cqlS/ewXovAibVy19/rYTT4nlBd2Uf
         ykPgciHnqw0AxUslVjukzWxqFWU4no9bBTLFD7KhY4i4pUORpCaKVfKOHdihQiCdfj
         2EzR+QcotZDY/uLpmxvkbmKTvH96FG1Kxmfn25wC57FXDkmSBjjbIKT9RrzgCb4/+2
         BR+ywCcGMnt7WCTVS4I40iz/u6vqybB0xIovvsv1lS3Vs6Y6hVahlZ06GOz1P8vUO/
         rIWDx5h2pczuw==
Date:   Sun, 11 Dec 2022 19:54:54 -0800
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yuzhe@nfschina.com,
        yuehaibing@huawei.com, weiyongjun1@huawei.com,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        manfred@colorfullife.com, longman@redhat.com, legion@kernel.org,
        jingyuwang_vip@163.com, ebiederm@xmission.com,
        shaozhengchao@huawei.com
Subject: Re: [merged mm-nonmm-stable]
 ipc-fix-memory-leak-in-init_mqueue_fs.patch removed from -mm tree
Message-ID: <20221212035454.rj6mop5gdu5uutpo@offworld>
References: <20221212033123.2B9B1C433F1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221212033123.2B9B1C433F1@smtp.kernel.org>
User-Agent: NeoMutt/20220429
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, 11 Dec 2022, Andrew Morton wrote:

>
>The quilt patch titled
>     Subject: ipc: fix memory leak in init_mqueue_fs()
>has been removed from the -mm tree.  Its filename was
>     ipc-fix-memory-leak-in-init_mqueue_fs.patch
>
>This patch was dropped because it was merged into the mm-nonmm-stable branch
>of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>------------------------------------------------------
>From: Zhengchao Shao <shaozhengchao@huawei.com>
>Subject: ipc: fix memory leak in init_mqueue_fs()
>Date: Fri, 9 Dec 2022 17:29:29 +0800
>
>When setup_mq_sysctls() failed in init_mqueue_fs(), mqueue_inode_cachep is
>not released.  In order to fix this issue, the release path is reordered.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
