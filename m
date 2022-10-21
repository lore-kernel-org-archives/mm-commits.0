Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3040FFA373D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 17:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJURMO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 13:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiJURMN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 13:12:13 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD05C2751A9
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 10:12:12 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id u7so2215143qvn.13
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 10:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fA23PvnW2TkEor3AGh4qqWJ27zBPKP6Rq7CyNG5ZoaQ=;
        b=F9iesT9sVOBML10kVss+fxf/+/rIWx7ZVI0+qHddifn2dCRWDIjFZFYxS5vQRMMowi
         fH1ez7hyh0pthAxEdO8vzPtuVNHasINp6Ow6mf9CF9QMw+xAdkzSsS8d6HT3ohx92eY1
         73gEQNXDvyI8VcMSyIyjBwhbaVSF4uw2hPjP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fA23PvnW2TkEor3AGh4qqWJ27zBPKP6Rq7CyNG5ZoaQ=;
        b=iZeLPFxCxHuh+VgB73abEvBSfy0d5QBq9Eif2B4B3afsmBs1KpAijugQ/cuHBnNbt+
         C6kqIcO7k7xX7ehgoDSXimalvc5VCJ39TkeQKL47GJZfDdOxApYJMzxvM5cHAEonC/B9
         N3CLawUw2YrwRieex8PTTFJuPG6+I5pZ07oeEexcz+1IY3koH4B7/7Dvsdut+msdfHGI
         aY+h4YwGOb/dKEycyttMMsrZttlpUqVWVXnBeCJvIy8pYEby+08IDHIzIt83P5JCABk0
         3KxRnr1f6cFKzSljwck6Pyf9TySmJVeF/oxE3Zpr9Q3szYQW7FFGwhi5PnYXcXf6wDSG
         NiFg==
X-Gm-Message-State: ACrzQf0DGW/l10xSCwCZEt5xD8VR94FKQLfVTaUZLp/ibmA7yCR2Do0X
        Ja1ljNWMBlA9QrvWoWLXn7UwH/74VXil9w==
X-Google-Smtp-Source: AMsMyM6kAwyFP/NAzm/MEckrQtgtdv+CUUCdE3oAOUkjeCQvPLRVNb6zvBaGUvwX9jaR/gry7DE+hw==
X-Received: by 2002:a0c:e04e:0:b0:4b1:cae6:4b0a with SMTP id y14-20020a0ce04e000000b004b1cae64b0amr18002271qvk.121.1666372331687;
        Fri, 21 Oct 2022 10:12:11 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id bj41-20020a05620a192900b006bb29d932e1sm9925415qkb.105.2022.10.21.10.12.08
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 10:12:09 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-36847dfc5ccso30304887b3.0
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 10:12:08 -0700 (PDT)
X-Received: by 2002:a81:11d0:0:b0:35b:dd9f:5358 with SMTP id
 199-20020a8111d0000000b0035bdd9f5358mr17690127ywr.401.1666372328545; Fri, 21
 Oct 2022 10:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221020000356.177CDC433C1@smtp.kernel.org> <Y1EZuQcO8UoN91cX@localhost.localdomain>
 <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
 <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com> <Y1I1S86zbBmeJ+jq@localhost.localdomain>
In-Reply-To: <Y1I1S86zbBmeJ+jq@localhost.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 21 Oct 2022 10:11:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgb3RYTPd24rXs8dRdiqiPAzq7uc4Suxu1On6_DTDnf5g@mail.gmail.com>
Message-ID: <CAHk-=wgb3RYTPd24rXs8dRdiqiPAzq7uc4Suxu1On6_DTDnf5g@mail.gmail.com>
Subject: Re: [PATCH -mm] -funsigned-char, x86: make struct p4_event_bind::cntr
 signed array
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com
Content-Type: multipart/mixed; boundary="000000000000b548f505eb8e8ad9"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--000000000000b548f505eb8e8ad9
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 20, 2022 at 10:59 PM Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> It is very entertaining, i've given up and started patching sparse
> but it needs more because char constants are ints:

I think you can fix that by simply warning about character constants
with the high bit set.

Something like this..

              Linus

--000000000000b548f505eb8e8ad9
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_l9ir1rfw0>
X-Attachment-Id: f_l9ir1rfw0

IGNoYXIuYyB8IDQgKysrKwogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlmZiAt
LWdpdCBhL2NoYXIuYyBiL2NoYXIuYwppbmRleCA3MzBhZTNmNS4uMzcwNmUwMzMgMTAwNjQ0Ci0t
LSBhL2NoYXIuYworKysgYi9jaGFyLmMKQEAgLTkzLDYgKzkzLDEwIEBAIHZvaWQgZ2V0X2NoYXJf
Y29uc3RhbnQoc3RydWN0IHRva2VuICp0b2tlbiwgdW5zaWduZWQgbG9uZyBsb25nICp2YWwpCiAJ
aWYgKHAgIT0gZW5kKQogCQl3YXJuaW5nKHRva2VuLT5wb3MsCiAJCQkibXVsdGktY2hhcmFjdGVy
IGNoYXJhY3RlciBjb25zdGFudCIpOworCWlmICh2ICYgMHg4MCkgeworCQlpZiAodHlwZSA+PSBU
T0tFTl9DSEFSICYmIHR5cGUgPD0gVE9LRU5fQ0hBUl9FTUJFRERFRF8zKQorCQkJd2FybmluZyh0
b2tlbi0+cG9zLCAiY2hhcmFjdGVyIGNvbnN0YW50IHdpdGggc2lnbiBiaXQgc2V0Iik7CisJfQog
CSp2YWwgPSB2OwogfQogCg==
--000000000000b548f505eb8e8ad9--
