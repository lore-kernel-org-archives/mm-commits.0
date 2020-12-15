Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 650B1C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 21:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 282EC22CBB
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 21:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgLOVIt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 16:08:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34376 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgLOVIp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 16:08:45 -0500
Received: by mail-wm1-f65.google.com with SMTP id g25so669532wmh.1
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 13:08:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:from:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5sVr9jzVRKEhEKffRGz0Z+UwJ5XVykBhE5DtnE48YT0=;
        b=YzyCE9ncXx+RdHeK9e7wK4x8CPf0dDa0jiZNSzkh1/CdQdktBYf8YETPGWJnkOoOW4
         iAxbEp5IE5Lg+clQXSnDmqfLiD4u//reJiTWHxHrE0vHT2wX+V+kVlb4hUHl8nLOuM79
         DkRbnkr83Xc8MnL1OKHJhoRUqsb1Yb76TROqZevc+VFqT5Zb/hqZ7Oh8sPMhC8xf9nU5
         AOhGmQOi+NSMJXr7G+Brd6VPxHq7WpdHY642yKk/coFJoqBLrAh+v4EtWB3is9UkoNDi
         n5gwCu2OL+Prw20TeLePEz8G8dqO7PcAoEft4KwaLM8otFUvKo9Ee1rjUJNqjRKpIEn8
         W0zA==
X-Gm-Message-State: AOAM533x5SmHSU8dLqCSxs5OfH5JppaBt4S1IkU9E7P0aXBKXIkxL4s2
        gzkr6RXDpjmSIgz46fJBqtQ=
X-Google-Smtp-Source: ABdhPJx3x6wayhKAV3sGPSPcoMUDetyiI3Hz4qmD5cbmErqnLybY1Al9tI+tu6gyCQ6msAWPGWJDNw==
X-Received: by 2002:a1c:7213:: with SMTP id n19mr651147wmc.14.1608066484271;
        Tue, 15 Dec 2020 13:08:04 -0800 (PST)
Received: from [10.9.0.22] ([185.248.161.177])
        by smtp.gmail.com with ESMTPSA id v11sm9884198wrt.25.2020.12.15.13.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 13:08:03 -0800 (PST)
Subject: Re: [patch 022/200] mm/slab: rerform init_on_free earlier
From:   Alexander Popov <alex.popov@linux.com>
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
 <901796dc-4ce9-f9be-308b-5d26ed20b208@linux.com>
Message-ID: <8e5b5abb-2704-66ae-b4fa-d77dc8266bf4@linux.com>
Date:   Wed, 16 Dec 2020 00:08:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <901796dc-4ce9-f9be-308b-5d26ed20b208@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 15.12.2020 23:46, Alexander Popov wrote:
> On 15.12.2020 19:45, Alexander Potapenko wrote:
>> On Tue, Dec 15, 2020 at 4:04 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>> From: Alexander Popov <alex.popov@linux.com>
>>> Subject: mm/slab: rerform init_on_free earlier
>>
>> Nit: s/rerform/perform
> 
> Right, thanks, Alexander!
> 
> Andrew, should I resend the patch?

Hm, this typo is not from my patch.
I guess my resending is not needed.

Best regards,
Alexander
