Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5639C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 11:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 592F264F0F
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 11:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBYLIB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 06:08:01 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:40440 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231335AbhBYLH7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Feb 2021 06:07:59 -0500
X-UUID: 26a41181d2304b19b736388e3d37d796-20210225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=EoxH8nxIL++xtiNGqc0Is8rihip7r1SRKZ+MdbneffU=;
        b=Y29keS7Wp0ZJH/0PvHg1YSljoCCs9ts4O3tIDFQcIDnAXpItqBGgi1BETn0DL0LDWQ77m4O9DRkGYuaMdfEkpmYxkfgjRysec1tnoR4oG6v86BA/P+B8UfsfTNjenF7qEr0x/ZYuOYz7eOTPjvJophAE3nYTLtGqOeZTMVibYrQ=;
X-UUID: 26a41181d2304b19b736388e3d37d796-20210225
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <walter-zh.wu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 320164400; Thu, 25 Feb 2021 19:07:09 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 25 Feb 2021 19:07:08 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Feb 2021 19:07:08 +0800
Message-ID: <1614251228.7523.2.camel@mtksdccf07>
Subject: Re: incoming
From:   Walter Wu <walter-zh.wu@mediatek.com>
To:     Andrey Ryabinin <ryabinin.a.a@gmail.com>
CC:     Arnd Bergmann <arnd@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Konovalov <andreyknvl@google.com>,
        Linux-MM <linux-mm@kvack.org>, <mm-commits@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>
Date:   Thu, 25 Feb 2021 19:07:08 +0800
In-Reply-To: <CAPAsAGz-xzkak9Cj5TuL_FZ86DTtrfybQtgeou-fSjc0UaZRig@mail.gmail.com>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
         <CAHk-=wiO1=xV1_gOsiWS9TuFJ_RQ0_HuXLg-qVAMnNj2TvHk2g@mail.gmail.com>
         <CAHk-=wibSMJcDmepGEDQ-O4-_d0KUQi4SAF0h3=fj3Ab3DbBdQ@mail.gmail.com>
         <CAK8P3a3PJZBJQN-=K8DRAWL8fcUa_FPm92HPFWfvZ5jcH-c7Dg@mail.gmail.com>
         <CAPAsAGz-xzkak9Cj5TuL_FZ86DTtrfybQtgeou-fSjc0UaZRig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

SGkgQW5kcmV5LA0KDQpPbiBUaHUsIDIwMjEtMDItMjUgYXQgMTI6MTIgKzAzMDAsIEFuZHJleSBS
eWFiaW5pbiB3cm90ZToNCj4gT24gVGh1LCBGZWIgMjUsIDIwMjEgYXQgMTE6NTMgQU0gQXJuZCBC
ZXJnbWFubiA8YXJuZEBrZXJuZWwub3JnPiB3cm90ZToNCj4gPg0KPiA+IE9uIFdlZCwgRmViIDI0
LCAyMDIxIGF0IDEwOjM3IFBNIExpbnVzIFRvcnZhbGRzDQo+ID4gPHRvcnZhbGRzQGxpbnV4LWZv
dW5kYXRpb24ub3JnPiB3cm90ZToNCj4gPiA+DQo+ID4gPiBPbiBXZWQsIEZlYiAyNCwgMjAyMSBh
dCAxOjMwIFBNIExpbnVzIFRvcnZhbGRzDQo+ID4gPiA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlv
bi5vcmc+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBIbW0uIEkgaGF2ZW4ndCBiaXNlY3RlZCB0
aGluZ3MgeWV0LCBidXQgSSBzdXNwZWN0IGl0J3Mgc29tZXRoaW5nIHdpdGgNCj4gPiA+ID4gdGhl
IEtBU0FOIHBhdGNoZXMuIFdpdGggdGhpcyBhbGwgYXBwbGllZCwgSSBnZXQ6DQo+ID4gPiA+DQo+
ID4gPiA+ICAgbGliL2NyeXB0by9jdXJ2ZTI1NTE5LWhhY2w2NC5jOiBJbiBmdW5jdGlvbiDigJhs
YWRkZXJfY211bHQuY29uc3Rwcm9w4oCZOg0KPiA+ID4gPiAgIGxpYi9jcnlwdG8vY3VydmUyNTUx
OS1oYWNsNjQuYzo2MDE6MTogd2FybmluZzogdGhlIGZyYW1lIHNpemUgb2YNCj4gPiA+ID4gMjI4
OCBieXRlcyBpcyBsYXJnZXIgdGhhbiAyMDQ4IGJ5dGVzIFstV2ZyYW1lLWxhcmdlci10aGFuPV0N
Cj4gPiA+ID4NCj4gPiA+ID4gYW5kDQo+ID4gPiA+DQo+ID4gPiA+ICAgbGliL2JpdGZpZWxkX2t1
bml0LmM6IEluIGZ1bmN0aW9uIOKAmHRlc3RfYml0ZmllbGRzX2NvbnN0YW50c+KAmToNCj4gPiA+
ID4gICBsaWIvYml0ZmllbGRfa3VuaXQuYzo5MzoxOiB3YXJuaW5nOiB0aGUgZnJhbWUgc2l6ZSBv
ZiAxMTIwMCBieXRlcyBpcw0KPiA+ID4gPiBsYXJnZXIgdGhhbiAyMDQ4IGJ5dGVzIFstV2ZyYW1l
LWxhcmdlci10aGFuPV0NCj4gPiA+ID4NCj4gPiA+ID4gd2hpY2ggaXMgb2J2aW91c2x5IG5vdCBy
ZWFsbHkgYWNjZXB0YWJsZS4gQSAxMWtCIHN0YWNrIGZyYW1lIF93aWxsXw0KPiA+ID4gPiBjYXVz
ZSBpc3N1ZXMuDQo+ID4gPg0KPiA+ID4gQSBxdWljayBiaXNlY3Qgc2hvZXMgdGhhdCB0aGlzIHdh
cyBpbnRyb2R1Y2VkIGJ5ICJbcGF0Y2ggMTAxLzE3M10NCj4gPiA+IGthc2FuOiByZW1vdmUgcmVk
dW5kYW50IGNvbmZpZyBvcHRpb24iLg0KPiA+ID4NCj4gPiA+IEkgZGlkbid0IGNoZWNrIHdoYXQg
cGFydCBvZiB0aGF0IHBhdGNoIHNjcmV3cyB1cCwgYnV0IGl0J3MgZGVmaW5pdGVseQ0KPiA+ID4g
ZG9pbmcgc29tZXRoaW5nIGJhZC4NCj4gPg0KPiA+IEknbSBub3Qgc3VyZSB3aHkgdGhhdCBwYXRj
aCBzdXJmYWNlZCB0aGUgYnVnLCBidXQgaXQncyB3b3J0aCBwb2ludGluZw0KPiA+IG91dCB0aGF0
IHRoZSB1bmRlcmx5aW5nIHByb2JsZW0gaXMgYXNhbi1zdGFjayBpbiBjb21iaW5hdGlvbg0KPiA+
IHdpdGggdGhlIHN0cnVjdGxlYWsgcGx1Z2luLiBUaGlzIHdpbGwgaGFwcGVuIGZvciBldmVyeSB1
c2VyIG9mIGt1bml0Lg0KPiA+DQo+IA0KPiBUaGUgcGF0Y2ggZGlkbid0IHVwZGF0ZSBLQVNBTl9T
VEFDSyBkZXBlbmRlbmN5IGluIGtjb25maWc6DQo+ICAgICAgICAgY29uZmlnIEdDQ19QTFVHSU5f
U1RSVUNUTEVBS19CWVJFRg0KPiAuLi4uDQo+ICAgICAgICAgICAgICAgIGRlcGVuZHMgb24gIShL
QVNBTiAmJiBLQVNBTl9TVEFDSz0xKQ0KPiANCj4gVGhpcyAnZGVwZW5kcyBvbicgIHN0b3BwZWQg
d29ya2luZyB3aXRoIHRoZSBwYXRjaA0KDQpUaGFua3MgZm9yIHBvaW50aW5nIG91dCB0aGlzIHBy
b2JsZW0uIEkgd2lsbCByZS1zZW5kIHRoYXQgcGF0Y2guDQoNCg0KV2FsdGVyDQo=

