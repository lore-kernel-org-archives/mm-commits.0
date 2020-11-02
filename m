Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2337C4742C
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 19:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9628C2225E
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 19:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604345960;
	bh=hia1SsBCRKKrWiFJ4LBwOtFOkl/Tr06NNNU/y1dWvVk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:Reply-To:List-ID:
	 From;
	b=JhhscTJGoNH155xfEUMMNIV8/4poYcDW7i5hSvTxZZ6tMnRxf7yL1NW23EV5OVlzT
	 gHIVSZDfgA6nlxPFX3KPxZfVNsXx29auBXuN60I9nUfjdEIifMw5uX+SwsbrHt5VLG
	 Vvb+P+JTfEtg+ynaENdq37Yh89OJPSW87+z9ysV4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgKBTjT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Nov 2020 14:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgKBTjS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2020 14:39:18 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BA3C0617A6
        for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2020 11:39:18 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id 141so18956366lfn.5
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 11:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tfb5vVj5QQ+OAYWUfIqZVQ3lxiwpfBxlP2NFYQgAzjw=;
        b=HA+CY21EOUHKv1iFxk/23+adlbBPNWK9Dxy0MvVa2XrwgFU6jvYY5RjCCmTVHPso0z
         L6+v7/PTBTzrDWTr2tQdwq+wyRpp7zFL6Vwk06RBzEneT9b0afIYa1jLhuKiLtW4PQ5b
         wLcnlO18vdCQ0cZ9u/8wfXYitCzHdUAanxGOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tfb5vVj5QQ+OAYWUfIqZVQ3lxiwpfBxlP2NFYQgAzjw=;
        b=G9V7viTvjHRqNeMxEYLMB05J2V2rpIDblBrhdQSJR3pSCk++r4WZKEvyi2xMXTxuLo
         AIqT1MsneD2pMGMqy6Nc3BHWZOFR38WHshEKtT57gkypXcj7x9+jq1aeLHSQAl/NyGt0
         DCyFx72ZNElk4pEddsoOXrHVegkcg4n0lGstBVokn25ehJn9aGzr5RJ6inq3OijPI+kB
         y66A0mvY08TmHAW2zooAmcGdbhEXd4k62djV4/5viR4esZLaygLe4xX2VUGSZQpVdYJ/
         rUodEF79EGZmkWlP6nU4stAL3ipiFgzmrDWlL0XQS23psoHMjnVjBf67MjxVCh1SBxa8
         NfvA==
X-Gm-Message-State: AOAM531NiVH4dsJkzVgmWWiG0gp6gjv6DVtnAGjFBf2hCgbIe7/9IKDP
        CNCUr66gm8/o1SP3lLvuSQ+RSFdrE2moOw==
X-Google-Smtp-Source: ABdhPJzKLuLAf3M8gjOhb1BeKYogOmYqxBN60vtE0TIsHbz8gM6beoPeEO8tIxheNOURbqimUKWp9w==
X-Received: by 2002:ac2:4d0c:: with SMTP id r12mr5932340lfi.74.1604345956261;
        Mon, 02 Nov 2020 11:39:16 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id j10sm2162162lfr.288.2020.11.02.11.39.10
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 11:39:11 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id y184so16992368lfa.12
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 11:39:10 -0800 (PST)
X-Received: by 2002:a19:c703:: with SMTP id x3mr5864072lff.105.1604345950419;
 Mon, 02 Nov 2020 11:39:10 -0800 (PST)
MIME-Version: 1.0
References: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
 <20201102010804.uENOQsZO9%akpm@linux-foundation.org> <CAHk-=wjweewYgnT2MX2iqbj2+7QamHH+pdMQGvr3duPL5a_dvA@mail.gmail.com>
 <CACSApvZmNAOCUEEs051G7bc9-JbSv1auh+xUvuitP6LkWfn-5w@mail.gmail.com> <CAHk-=wh3FcWMRAt-WGYcKP-YxLDBkpbNtVzLrm+=t6xixV+A9w@mail.gmail.com>
In-Reply-To: <CAHk-=wh3FcWMRAt-WGYcKP-YxLDBkpbNtVzLrm+=t6xixV+A9w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 2 Nov 2020 11:38:53 -0800
X-Gmail-Original-Message-ID: <CAHk-=wizk=OxUyQPbO8MS41w2Pag1kniUV5WdD5qWL-gq1kjDA@mail.gmail.com>
Message-ID: <CAHk-=wizk=OxUyQPbO8MS41w2Pag1kniUV5WdD5qWL-gq1kjDA@mail.gmail.com>
Subject: Re: [patch 13/15] epoll: check ep_events_available() upon timeout
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Dumazet <edumazet@google.com>,
        Guantao Liu <guantaol@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Willem de Bruijn <willemb@google.com>
Content-Type: multipart/mixed; boundary="00000000000078f4dd05b324e6a7"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--00000000000078f4dd05b324e6a7
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 2, 2020 at 10:51 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll go stare at it some more.

That code is fundamentally broken in so many ways.

Look at how  ep_poll() does that ep_events_available() without
actually holding the ep->lock (or the ep->mtx) in half the cases.

End result: it works in 99.9% of all cases, but there's a race with
somebody else doing

        WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
        /*
         * Quickly re-inject items left on "txlist".
         */
        list_splice(&txlist, &ep->rdllist);

when that code can see an empty rdllist and an inactive ovflist and
thus decide that there are no events available.

I think the "Quickly re-inject" comment may be because some people
knew of that race.

The signal handling is also odd and looks broken.

The "short circuit on fatal signals" means that ep_send_events() isn't
actually done on a SIGKILL, but the code also used an exclusive wait,
so nobody else will be woken up either.

Admittedly you can steal wakeups other ways, by simply not caring
about the end result, so maybe that's all just inherent in epoll
anyway. But it looks strange, and it seems pointless: the right thing
to do would seem to be simply to have a regular check for
signal_pending(), and returning -EINTR if rather than looping.

And that do { } while (0) is entirely pointless. It seems to exist in
order to use "break" instead of the goto that everything else does,
which I guess is nice, except the whole need for that comes from how
oddly the code is written.

Why doesn't this all do something like the attached instead?

NOTE! I did not bother to fix that ep_events_available() race.

                      Linus

--00000000000078f4dd05b324e6a7
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
Content-ID: <f_kh0y57ej0>
X-Attachment-Id: f_kh0y57ej0

IGZzL2V2ZW50cG9sbC5jIHwgMTE0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDU0IGluc2VydGlvbnMoKyks
IDYwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2V2ZW50cG9sbC5jIGIvZnMvZXZlbnRw
b2xsLmMKaW5kZXggNGRmNjExMjk1NjZkLi5kNDczMjMyN2Y1N2EgMTAwNjQ0Ci0tLSBhL2ZzL2V2
ZW50cG9sbC5jCisrKyBiL2ZzL2V2ZW50cG9sbC5jCkBAIC0xODY0LDg1ICsxODY0LDc5IEBAIHN0
YXRpYyBpbnQgZXBfcG9sbChzdHJ1Y3QgZXZlbnRwb2xsICplcCwgc3RydWN0IGVwb2xsX2V2ZW50
IF9fdXNlciAqZXZlbnRzLAogCSAqLwogCWVwX3Jlc2V0X2J1c3lfcG9sbF9uYXBpX2lkKGVwKTsK
IAotCWRvIHsKLQkJLyoKLQkJICogSW50ZXJuYWxseSBpbml0X3dhaXQoKSB1c2VzIGF1dG9yZW1v
dmVfd2FrZV9mdW5jdGlvbigpLAotCQkgKiB0aHVzIHdhaXQgZW50cnkgaXMgcmVtb3ZlZCBmcm9t
IHRoZSB3YWl0IHF1ZXVlIG9uIGVhY2gKLQkJICogd2FrZXVwLiBXaHkgaXQgaXMgaW1wb3J0YW50
PyBJbiBjYXNlIG9mIHNldmVyYWwgd2FpdGVycwotCQkgKiBlYWNoIG5ldyB3YWtldXAgd2lsbCBo
aXQgdGhlIG5leHQgd2FpdGVyLCBnaXZpbmcgaXQgdGhlCi0JCSAqIGNoYW5jZSB0byBoYXJ2ZXN0
IG5ldyBldmVudC4gT3RoZXJ3aXNlIHdha2V1cCBjYW4gYmUKLQkJICogbG9zdC4gVGhpcyBpcyBh
bHNvIGdvb2QgcGVyZm9ybWFuY2Utd2lzZSwgYmVjYXVzZSBvbgotCQkgKiBub3JtYWwgd2FrZXVw
IHBhdGggbm8gbmVlZCB0byBjYWxsIF9fcmVtb3ZlX3dhaXRfcXVldWUoKQotCQkgKiBleHBsaWNp
dGx5LCB0aHVzIGVwLT5sb2NrIGlzIG5vdCB0YWtlbiwgd2hpY2ggaGFsdHMgdGhlCi0JCSAqIGV2
ZW50IGRlbGl2ZXJ5LgotCQkgKi8KLQkJaW5pdF93YWl0KCZ3YWl0KTsKKwlpZiAoc2lnbmFsX3Bl
bmRpbmcoY3VycmVudCkpCisJCXJldHVybiAtRUlOVFI7CiAKLQkJd3JpdGVfbG9ja19pcnEoJmVw
LT5sb2NrKTsKLQkJLyoKLQkJICogQmFycmllcmxlc3MgdmFyaWFudCwgd2FpdHF1ZXVlX2FjdGl2
ZSgpIGlzIGNhbGxlZCB1bmRlcgotCQkgKiB0aGUgc2FtZSBsb2NrIG9uIHdha2V1cCBlcF9wb2xs
X2NhbGxiYWNrKCkgc2lkZSwgc28gaXQKLQkJICogaXMgc2FmZSB0byBhdm9pZCBhbiBleHBsaWNp
dCBiYXJyaWVyLgotCQkgKi8KLQkJX19zZXRfY3VycmVudF9zdGF0ZShUQVNLX0lOVEVSUlVQVElC
TEUpOwotCi0JCS8qCi0JCSAqIERvIHRoZSBmaW5hbCBjaGVjayB1bmRlciB0aGUgbG9jay4gZXBf
c2Nhbl9yZWFkeV9saXN0KCkKLQkJICogcGxheXMgd2l0aCB0d28gbGlzdHMgKC0+cmRsbGlzdCBh
bmQgLT5vdmZsaXN0KSBhbmQgdGhlcmUKLQkJICogaXMgYWx3YXlzIGEgcmFjZSB3aGVuIGJvdGgg
bGlzdHMgYXJlIGVtcHR5IGZvciBzaG9ydAotCQkgKiBwZXJpb2Qgb2YgdGltZSBhbHRob3VnaCBl
dmVudHMgYXJlIHBlbmRpbmcsIHNvIGxvY2sgaXMKLQkJICogaW1wb3J0YW50LgotCQkgKi8KLQkJ
ZWF2YWlsID0gZXBfZXZlbnRzX2F2YWlsYWJsZShlcCk7Ci0JCWlmICghZWF2YWlsKSB7Ci0JCQlp
ZiAoc2lnbmFsX3BlbmRpbmcoY3VycmVudCkpCi0JCQkJcmVzID0gLUVJTlRSOwotCQkJZWxzZQot
CQkJCV9fYWRkX3dhaXRfcXVldWVfZXhjbHVzaXZlKCZlcC0+d3EsICZ3YWl0KTsKLQkJfQotCQl3
cml0ZV91bmxvY2tfaXJxKCZlcC0+bG9jayk7Ci0KLQkJaWYgKGVhdmFpbCB8fCByZXMpCi0JCQli
cmVhazsKKwkvKgorCSAqIEludGVybmFsbHkgaW5pdF93YWl0KCkgdXNlcyBhdXRvcmVtb3ZlX3dh
a2VfZnVuY3Rpb24oKSwKKwkgKiB0aHVzIHdhaXQgZW50cnkgaXMgcmVtb3ZlZCBmcm9tIHRoZSB3
YWl0IHF1ZXVlIG9uIGVhY2gKKwkgKiB3YWtldXAuIFdoeSBpdCBpcyBpbXBvcnRhbnQ/IEluIGNh
c2Ugb2Ygc2V2ZXJhbCB3YWl0ZXJzCisJICogZWFjaCBuZXcgd2FrZXVwIHdpbGwgaGl0IHRoZSBu
ZXh0IHdhaXRlciwgZ2l2aW5nIGl0IHRoZQorCSAqIGNoYW5jZSB0byBoYXJ2ZXN0IG5ldyBldmVu
dC4gT3RoZXJ3aXNlIHdha2V1cCBjYW4gYmUKKwkgKiBsb3N0LiBUaGlzIGlzIGFsc28gZ29vZCBw
ZXJmb3JtYW5jZS13aXNlLCBiZWNhdXNlIG9uCisJICogbm9ybWFsIHdha2V1cCBwYXRoIG5vIG5l
ZWQgdG8gY2FsbCBfX3JlbW92ZV93YWl0X3F1ZXVlKCkKKwkgKiBleHBsaWNpdGx5LCB0aHVzIGVw
LT5sb2NrIGlzIG5vdCB0YWtlbiwgd2hpY2ggaGFsdHMgdGhlCisJICogZXZlbnQgZGVsaXZlcnku
CisJICovCisJaW5pdF93YWl0KCZ3YWl0KTsKIAotCQlpZiAoIXNjaGVkdWxlX2hydGltZW91dF9y
YW5nZSh0bywgc2xhY2ssIEhSVElNRVJfTU9ERV9BQlMpKSB7Ci0JCQl0aW1lZF9vdXQgPSAxOwot
CQkJYnJlYWs7Ci0JCX0KKwl3cml0ZV9sb2NrX2lycSgmZXAtPmxvY2spOworCS8qCisJICogQmFy
cmllcmxlc3MgdmFyaWFudCwgd2FpdHF1ZXVlX2FjdGl2ZSgpIGlzIGNhbGxlZCB1bmRlcgorCSAq
IHRoZSBzYW1lIGxvY2sgb24gd2FrZXVwIGVwX3BvbGxfY2FsbGJhY2soKSBzaWRlLCBzbyBpdAor
CSAqIGlzIHNhZmUgdG8gYXZvaWQgYW4gZXhwbGljaXQgYmFycmllci4KKwkgKi8KKwlfX3NldF9j
dXJyZW50X3N0YXRlKFRBU0tfSU5URVJSVVBUSUJMRSk7CiAKLQkJLyogV2Ugd2VyZSB3b2tlbiB1
cCwgdGh1cyBnbyBhbmQgdHJ5IHRvIGhhcnZlc3Qgc29tZSBldmVudHMgKi8KLQkJZWF2YWlsID0g
MTsKKwkvKgorCSAqIERvIHRoZSBmaW5hbCBjaGVjayB1bmRlciB0aGUgbG9jay4gZXBfc2Nhbl9y
ZWFkeV9saXN0KCkKKwkgKiBwbGF5cyB3aXRoIHR3byBsaXN0cyAoLT5yZGxsaXN0IGFuZCAtPm92
Zmxpc3QpIGFuZCB0aGVyZQorCSAqIGlzIGFsd2F5cyBhIHJhY2Ugd2hlbiBib3RoIGxpc3RzIGFy
ZSBlbXB0eSBmb3Igc2hvcnQKKwkgKiBwZXJpb2Qgb2YgdGltZSBhbHRob3VnaCBldmVudHMgYXJl
IHBlbmRpbmcsIHNvIGxvY2sgaXMKKwkgKiBpbXBvcnRhbnQuCisJICovCisJZWF2YWlsID0gZXBf
ZXZlbnRzX2F2YWlsYWJsZShlcCk7CisJaWYgKCFlYXZhaWwpCisJCV9fYWRkX3dhaXRfcXVldWVf
ZXhjbHVzaXZlKCZlcC0+d3EsICZ3YWl0KTsKKwl3cml0ZV91bmxvY2tfaXJxKCZlcC0+bG9jayk7
CiAKLQl9IHdoaWxlICgwKTsKKwlpZiAoIWVhdmFpbCkKKwkJdGltZWRfb3V0ID0gIXNjaGVkdWxl
X2hydGltZW91dF9yYW5nZSh0bywgc2xhY2ssIEhSVElNRVJfTU9ERV9BQlMpOwogCiAJX19zZXRf
Y3VycmVudF9zdGF0ZShUQVNLX1JVTk5JTkcpOwogCisJLyoKKwkgKiBJZiB3ZSB3ZXJlIHdva2Vu
IHVwLCBhc3N1bWUgdGhlcmUncyBzb21ldGhpbmcgYXZhaWxhYmxlLCBvdGhlcndpc2UKKwkgKiBy
ZW1vdmUgb3Vyc2VsdmVzIGZyb20gdGhlIHdhaXQgcXVldWUgYW5kIGNoZWNrIGNhcmVmdWxseSAo
c2luY2Ugd2UKKwkgKiBob2xkIHRoZSBsb2NrIGFueXdheSkuCisJICovCisJZWF2YWlsID0gMTsK
IAlpZiAoIWxpc3RfZW1wdHlfY2FyZWZ1bCgmd2FpdC5lbnRyeSkpIHsKIAkJd3JpdGVfbG9ja19p
cnEoJmVwLT5sb2NrKTsKIAkJX19yZW1vdmVfd2FpdF9xdWV1ZSgmZXAtPndxLCAmd2FpdCk7CisJ
CWVhdmFpbCA9IGVwX2V2ZW50c19hdmFpbGFibGUoZXApOwogCQl3cml0ZV91bmxvY2tfaXJxKCZl
cC0+bG9jayk7CiAJfQogCiBzZW5kX2V2ZW50czoKLQlpZiAoZmF0YWxfc2lnbmFsX3BlbmRpbmco
Y3VycmVudCkpIHsKLQkJLyoKLQkJICogQWx3YXlzIHNob3J0LWNpcmN1aXQgZm9yIGZhdGFsIHNp
Z25hbHMgdG8gYWxsb3cKLQkJICogdGhyZWFkcyB0byBtYWtlIGEgdGltZWx5IGV4aXQgd2l0aG91
dCB0aGUgY2hhbmNlIG9mCi0JCSAqIGZpbmRpbmcgbW9yZSBldmVudHMgYXZhaWxhYmxlIGFuZCBm
ZXRjaGluZwotCQkgKiByZXBlYXRlZGx5LgotCQkgKi8KLQkJcmVzID0gLUVJTlRSOworCWlmIChy
ZXMpCisJCXJldHVybiByZXM7CisJaWYgKGVhdmFpbCkgeworCQlyZXMgPSBlcF9zZW5kX2V2ZW50
cyhlcCwgZXZlbnRzLCBtYXhldmVudHMpOworCQlpZiAocmVzKQorCQkJcmV0dXJuIHJlczsKIAl9
CisJaWYgKHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKQorCQlyZXR1cm4gLUVJTlRSOworCiAJLyoK
LQkgKiBUcnkgdG8gdHJhbnNmZXIgZXZlbnRzIHRvIHVzZXIgc3BhY2UuIEluIGNhc2Ugd2UgZ2V0
IDAgZXZlbnRzIGFuZAotCSAqIHRoZXJlJ3Mgc3RpbGwgdGltZW91dCBsZWZ0IG92ZXIsIHdlIGdv
IHRyeWluZyBhZ2FpbiBpbiBzZWFyY2ggb2YKLQkgKiBtb3JlIGx1Y2suCisJICogSW4gY2FzZSB3
ZSBnZXQgMCBldmVudHMgYW5kIHRoZXJlJ3Mgc3RpbGwgdGltZW91dCBsZWZ0IG92ZXIsIHdlCisJ
ICogZ28gdHJ5aW5nIGFnYWluIGluIHNlYXJjaCBvZiBtb3JlIGx1Y2suCiAJICovCi0JaWYgKCFy
ZXMgJiYgZWF2YWlsICYmCi0JICAgICEocmVzID0gZXBfc2VuZF9ldmVudHMoZXAsIGV2ZW50cywg
bWF4ZXZlbnRzKSkgJiYgIXRpbWVkX291dCkKKwlpZiAoIXRpbWVkX291dCkKIAkJZ290byBmZXRj
aF9ldmVudHM7CiAKLQlyZXR1cm4gcmVzOworCXJldHVybiAwOwogfQogCiAvKioK
--00000000000078f4dd05b324e6a7--
