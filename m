Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0C6C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 19:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D729A61963
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 19:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237977AbhCXTsb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237930AbhCXTsK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Mar 2021 15:48:10 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5FAC061763
        for <mm-commits@vger.kernel.org>; Wed, 24 Mar 2021 12:48:10 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id r8so101056ilo.8
        for <mm-commits@vger.kernel.org>; Wed, 24 Mar 2021 12:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1eZORvXtUagHzKvDk3g3eaa5HEqTMav+blnIK2kgohQ=;
        b=eGN0+si3Pb6p0Uik1rXOaoqnPC7HlOJbYZZYoVf0tuRiNK44sB5l8+cdlV4f/Nji1H
         pW4Y2GtveaewCfj6vcyJpydx5Ji2RHHeHSObgKjuAbJiEiwLRuAcf+bgPMEupZUOQ/1V
         W2ZFSm4wpm0QRO3LSLXeuETI0hkBztfZl9Y0XlPsbBLdKICBuUVNFSfHsersJIMuSOt6
         QkAXLafAlSakZH8hE5YZeamODqQCg2VrXNShm0adTOYponaie/X8TL14v4sOv1QH0Ojc
         b/qQlauq4fqUj4QGPJ6ZdOheS0wRFkqPtRtj7dmqDOvaPHBAvhbtxlqH2UvCsghC27YY
         6F5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1eZORvXtUagHzKvDk3g3eaa5HEqTMav+blnIK2kgohQ=;
        b=q67v60Q0CC/Zg9eKsutfLbXJt2EKTIdykVnE4ATgB4wegHvc0aN2wMQ490qwrV6Rh4
         5HixJV33dF5z7IT6AU5Wy9Dg2ERnVLZm+p+LfCo9rr3oYN1QpaBDsQ65LvKz1qwzWTNw
         foROvzao2EFkDvBgrKCCagtR8NiorkMNKCKrDWChjZFjUB79P4WxMit5QVhEwXcG1zM2
         q3jJ0aJ7ls9mL3i+ROEMiaJ0P1kh9+dDvWxKiK0P4AwrZRRS0ki3OVALEBY+kJvk6Vcw
         CqlrzOex8/SxZlff5BYo3ih5TJxsG1E2NfeJA3zg3sZjTMeNuv7CLrC45CM64p2bgBwR
         xqzQ==
X-Gm-Message-State: AOAM533b3hmhQzgapZAwITmKAB5AEylHV75aKEhDIuS2FRr7RTmg9vzG
        eisf9qm1ClGFR0bK+FgKTCj38A==
X-Google-Smtp-Source: ABdhPJztanVgk3/l1s7msuOIkZz/K+qYfQDbWLSJHOBL9aY38K66MjO40PizIU/TcS8aKaeIcnIrAQ==
X-Received: by 2002:a92:c5c6:: with SMTP id s6mr4023868ilt.168.1616615289821;
        Wed, 24 Mar 2021 12:48:09 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t9sm1472045ioi.27.2021.03.24.12.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:48:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: + mm-provide-filemap_range_needs_writeback-helper.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jan Kara <jack@suse.cz>, mm-commits@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
References: <20210302234347.N9evDxn__%akpm@linux-foundation.org>
Message-ID: <9c04eafc-475d-31fc-e2cc-ea99aafd8972@kernel.dk>
Date:   Wed, 24 Mar 2021 13:48:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210302234347.N9evDxn__%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Mar 2, 2021 at 4:43 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm: provide filemap_range_needs_writeback() helper
> has been added to the -mm tree.  Its filename is
>      mm-provide-filemap_range_needs_writeback-helper.patch

Are you still planning on flushing this out for 5.12??

-- 
Jens Axboe

