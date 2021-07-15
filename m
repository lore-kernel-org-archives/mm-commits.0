Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA57C07E96
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 13:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E524061374
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 13:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbhGONzB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 09:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhGONzB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jul 2021 09:55:01 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1578CC06175F
        for <mm-commits@vger.kernel.org>; Thu, 15 Jul 2021 06:52:08 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id p202so5185989qka.12
        for <mm-commits@vger.kernel.org>; Thu, 15 Jul 2021 06:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WOtIhKC8RiEkmTHieDAq65Q6AwB2yFROggAg00dRKkM=;
        b=tn9DXcZyImRQ8THOHjHdmchVy6sVIphjB/5uYXBlbeZ49Ar37cBAVay+11DpsytbzQ
         v7jTYspsZ4YHn4eP8QT/o7qCEnJkpVPMUhmHLVvGMfx5uKIaLv489uckXff9vFxxLs1V
         8iBNuP4oqFGocy4IXcig1JXvsrssco8xkL8u9kfLCmAnXFFGSPtyv8mKHfSBgX3NMtwP
         2uzqZX/IktknMDFVa/DoasN82+BOG1Z2z26BzfbZyQB6b0DvA0DSAyY0tOoMbKUmlAgT
         73hzvXAvKaCYVBHmgZTLM3Xvs2SM09KTR6aS2m6cQVDTPUfz9PSwGIZ0bUZ3wlvc97Z0
         uUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WOtIhKC8RiEkmTHieDAq65Q6AwB2yFROggAg00dRKkM=;
        b=o5hTz6cPePRgnF2Gy/klSdKGq5X7Ywgl6pTx/7OgBYlODyWdk+PQsFdFCEgdktWYJL
         qhQsNpXLtIgTyRnM/i5zC490QECMfdy/VrZ9FHY/OeHvBTW9dO4OlJU2Mx2gmvnUmyY7
         +fjPM8WHJWr5FWYA7agcDRfSxitO/uUqrfhIwzZK22YD/4mH55yDIodrKuSIKsfga5pE
         +9TYam7AISnFYa/NvJ8HZieZ48OLSKfpWu3ffC2z8ZQSVtNYAlXYwnnEgRH+JaM3BjC7
         NupNuzPZ5ykzpLTJsP04BphWODAKWlmuq9iGmeQd6pYupV+0Xv1B8/Ggktp9USjXBbG8
         JPEQ==
X-Gm-Message-State: AOAM530MWRwrJfclavdfJmryP5QUJUTnNXpB/0rDlXsKQsj03deDcUN4
        WKz2QtErtYPAQwokKfWq1ruuXIrHaJTeduLDZ3AkDQ==
X-Google-Smtp-Source: ABdhPJxHitSu7kv7K8vYpfCwFPk+39nnv4juqPbD0x0NVPHWy4GnXiZVwu0zLQxNJWq7PBHwpToLlY8umBXyAWdzjOU=
X-Received: by 2002:a37:a5ca:: with SMTP id o193mr4090068qke.352.1626357126991;
 Thu, 15 Jul 2021 06:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210714224225.Gmo7sht2E%akpm@linux-foundation.org>
In-Reply-To: <20210714224225.Gmo7sht2E%akpm@linux-foundation.org>
From:   Alexander Potapenko <glider@google.com>
Date:   Thu, 15 Jul 2021 15:51:30 +0200
Message-ID: <CAG_fn=U1U2b4Q_rvT8MzkdaAW0cqWkEyjmeE2BiZE=vymEKe9w@mail.gmail.com>
Subject: Re: + kfence-skip-all-gfp_zonemask-allocations.patch added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Dmitriy Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jul 15, 2021 at 12:42 AM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: kfence: skip all GFP_ZONEMASK allocations
> has been added to the -mm tree.  Its filename is
>      kfence-skip-all-gfp_zonemask-allocations.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/kfence-skip-all-gfp_zonemask-allocations.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/kfence-skip-all-gfp_zonemask-allocations.patch

Hi Andrew,

mmotm and mmots were last updated on 2021-06-25, did some automation break?
