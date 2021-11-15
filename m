Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BDAC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 20:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4800B619E3
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 20:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347254AbhKOUhs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 15:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347717AbhKOTmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 Nov 2021 14:42:55 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BC8C061570
        for <mm-commits@vger.kernel.org>; Mon, 15 Nov 2021 11:39:57 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id w199so3843611oiw.4
        for <mm-commits@vger.kernel.org>; Mon, 15 Nov 2021 11:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f8QjUQHYKxcUA/Y8KIeAbBLkiHJtaz31XO51VshdBhE=;
        b=APNbux0b5xrJgX5qqDRvThj9wyHsjCKsPHlPPvDDwy6CE+FENWwtsMsbK1cfIBYoV1
         qt8SuPC34Wq3IsSVpXkrBIoehPGVhm6Li7Ba5mA0AF86ROWD0xEKe/Ul1BVxUZy+fY8M
         tLNcZAgwIiHksFGijwyo1x0t6EUX29bDTuY2oweNraBZjyggHvOmlvqdlzNJacKX5bvd
         +Or+M0F/wqxnh1cSgQmi8A9CbUo5ZwBNs942gd3zK3ViqoSPa8vQi5wh0JslwUfHZ4cm
         wQFx5n7RxBOCenYlpGCawdQ3/nAyrbFq8s2traMyQUqdKbtMSOUNgHGaRR5GTOAWfIAN
         S41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f8QjUQHYKxcUA/Y8KIeAbBLkiHJtaz31XO51VshdBhE=;
        b=RT66ojVk9bouNZpWCCqBQC2ho3yeE+XrRS5ncg5sBJLMVAQWTKNemDHpxaHyzxwyRQ
         jNqymoQ4aeNr2tcH0/PejXY7Nr+8JFaI1Ss0ZQ1WoQyq0VKPDA2V9yppLpZPypHirTJ/
         QW7Nh1yOwF/koHek23LpmZPq8sT+pnZ0CzWak+Pn7aMZjS+IU994zHbJvtSW5/BVOySR
         Bhs3HwSP8Of5+sWA97wP1woghd8mIJt7PNg30DaaXDuKetkuzBzivOF7muAQJYwxisfG
         uT3fgZp5JSNaMpSMh4XR9QergtqpdXMr/7mwP1E4gI8a1+5qeUblJT8qiXHu6yCshBed
         4sCg==
X-Gm-Message-State: AOAM5310w4obzrUr94DBnqaw/JBQc1QoMQPF1c9zxOrLPBPkn3jwp3l2
        T/Fjz8+fLbWnkV3JdvmROq6L/Q2bYRs5yO7a3xKOD6g8DU8=
X-Google-Smtp-Source: ABdhPJxfuJbpl+sbSEa+HfVyjG3+lXU3PNQB9PYaF7n5A0NduiGbeidc3n02RfvuXJxxp/FD0ZgKBbphFy62/3KeQ1c=
X-Received: by 2002:a05:6808:1903:: with SMTP id bf3mr36769410oib.7.1637005196523;
 Mon, 15 Nov 2021 11:39:56 -0800 (PST)
MIME-Version: 1.0
References: <20211115183337.-JrkuEgrc%akpm@linux-foundation.org>
In-Reply-To: <20211115183337.-JrkuEgrc%akpm@linux-foundation.org>
From:   Marco Elver <elver@google.com>
Date:   Mon, 15 Nov 2021 20:39:44 +0100
Message-ID: <CANpmjNN8z7jnR5_prtBt0Qr-K4jmjJCvzvxOj=dnkKj0sCSATQ@mail.gmail.com>
Subject: Re: + panic-use-error_report_end-tracepoint-on-warnings-fix.patch
 added to -mm tree
To:     akpm@linux-foundation.org
Cc:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 15 Nov 2021 at 19:33, <akpm@linux-foundation.org> wrote:
[...]
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: panic-use-error_report_end-tracepoint-on-warnings-fix
>
> add comma to enum list, per Andy.

Thanks, Andrew. I wanted to send v2 tomorrow, in case there were more
comments. I'll skip sending v2 in this case.

Thanks,
-- Marco
