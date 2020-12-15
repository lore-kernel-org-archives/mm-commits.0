Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C5FC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CD4222C7D
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgLOUrH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 15:47:07 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:32787 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgLOUrG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 15:47:06 -0500
Received: by mail-wr1-f43.google.com with SMTP id t30so3142007wrb.0
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 12:46:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5Hk9844aPJ3lc10LYZindZms0kRMmjEZxVgAENN7Oow=;
        b=q8CRpoIEf0I//v7hNjTQ7Bswh1I7RZttuRMbMy2xzmKFjnMLcW7dasrIOqcv8k7UgO
         +gO0yQmKQgKxlSZDew7RSt4njaZl/OFgyhGYcjE1FiIi6Qi0jwkkJ7GhUqVxRM7e1gmn
         wNbc/Sifvmis4Z71oJz40bH0C/vbezbp8RraB2yIgnsruaVwZKI03wDoXkGC9qetAebS
         NeG87+t6cyvcXx4G+xQLFH4fEyaekmibT1yxb7Zo8Z0DE0+fXI3K7tRxJm3MOTyLRonE
         oguYJc7um6jkugT0dU+f6/RWtAG+QNgt8p6dnP00MntIP/0d/ExRVvbENCwdMd4y7EDq
         2Igw==
X-Gm-Message-State: AOAM532xREjfBihH1XYGZ+NyWAod0D+yG25QsGyHivef/ziTra0bNOVX
        n081jHAa+X3pnZc8MrxKJ3WCzKVqMwU=
X-Google-Smtp-Source: ABdhPJyMEHm5EQ6UUVd2cfUn3ngDXyAgjfoCp2ggs5QnICXjTUADnxHij9l8KGqBIoxpyTtGz7/SGQ==
X-Received: by 2002:a5d:5049:: with SMTP id h9mr27762175wrt.404.1608065183928;
        Tue, 15 Dec 2020 12:46:23 -0800 (PST)
Received: from [10.9.0.22] ([185.248.161.177])
        by smtp.gmail.com with ESMTPSA id l5sm29025486wrv.44.2020.12.15.12.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 12:46:23 -0800 (PST)
Subject: Re: [patch 022/200] mm/slab: rerform init_on_free earlier
To:     Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
 <20201215030433.7QkafHjX1%akpm@linux-foundation.org>
 <CAG_fn=XB04sOCu0Uhhq9Lb0fYwY4M0gpk_gnd43_rdqD0=Ur3w@mail.gmail.com>
From:   Alexander Popov <alex.popov@linux.com>
Message-ID: <901796dc-4ce9-f9be-308b-5d26ed20b208@linux.com>
Date:   Tue, 15 Dec 2020 23:46:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAG_fn=XB04sOCu0Uhhq9Lb0fYwY4M0gpk_gnd43_rdqD0=Ur3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 15.12.2020 19:45, Alexander Potapenko wrote:
> On Tue, Dec 15, 2020 at 4:04 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> From: Alexander Popov <alex.popov@linux.com>
>> Subject: mm/slab: rerform init_on_free earlier
> 
> Nit: s/rerform/perform

Right, thanks, Alexander!

Andrew, should I resend the patch?
