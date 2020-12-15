Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE00C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 09:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CA0522255
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 09:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgLOJH7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 04:07:59 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:39180 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727059AbgLOJHr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 04:07:47 -0500
X-UUID: b665afde9f40448a972f4955bb808aac-20201215
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Ojpub1SiMHiWYqHlKQErCu9iAsl4FqEUqiU/6k9yKHo=;
        b=R7i74yNpsiZrkI5rjgLXjXtcHIrPPErqZqnfdMUWxZjlFmJThVc52j4jd759tQeW3wTbKh4UobEvgzVy7e69G34A4YDM2ip8HqpqEpTrdzrVkEAAcyi5q2VnwsAH9nmK+zYaJlEApME/wEA530f41Swx8XB3jPVSu6TUYyh6b/I=;
X-UUID: b665afde9f40448a972f4955bb808aac-20201215
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <kuan-ying.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1141914617; Tue, 15 Dec 2020 17:06:59 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 17:06:58 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 17:06:58 +0800
Message-ID: <1608023217.31376.35.camel@mtksdccf07>
Subject: Re: [merged]
 kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch removed from
 -mm tree
From:   Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     <aryabinin@virtuozzo.com>, <dvyukov@google.com>,
        <glider@google.com>, <guangye.yang@mediatek.com>,
        <matthias.bgg@gmail.com>, <miles.chen@mediatek.com>,
        <mm-commits@vger.kernel.org>, <nicholas.tang@mediatek.com>,
        <qcai@redhat.com>, <qiang.zhang@windriver.com>,
        <sfr@canb.auug.org.au>
Date:   Tue, 15 Dec 2020 17:06:57 +0800
In-Reply-To: <20201214101957.51e0e05d2b7bf5d2f9707bd2@linux-foundation.org>
References: <20201213060524.pmMPPz32b%akpm@linux-foundation.org>
         <1607924810.31376.14.camel@mtksdccf07>
         <20201214101957.51e0e05d2b7bf5d2f9707bd2@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

T24gTW9uLCAyMDIwLTEyLTE0IGF0IDEwOjE5IC0wODAwLCBBbmRyZXcgTW9ydG9uIHdyb3RlOg0K
PiBPbiBNb24sIDE0IERlYyAyMDIwIDEzOjQ2OjUwICswODAwIEt1YW4tWWluZyBMZWUgPEt1YW4t
WWluZy5MZWVAbWVkaWF0ZWsuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gU2F0LCAyMDIwLTEyLTEy
IGF0IDIyOjA1IC0wODAwLCBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnIHdyb3RlOg0KPiA+ID4g
VGhlIHBhdGNoIHRpdGxlZA0KPiA+ID4gICAgICBTdWJqZWN0OiBrYXNhbjogZml4IG9iamVjdCBy
ZW1haW5pbmcgaW4gb2ZmbGluZSBwZXItY3B1IHF1YXJhbnRpbmUNCj4gPiA+IGhhcyBiZWVuIHJl
bW92ZWQgZnJvbSB0aGUgLW1tIHRyZWUuICBJdHMgZmlsZW5hbWUgd2FzDQo+ID4gPiAgICAgIGth
c2FuLWZpeC1vYmplY3QtcmVtYWluLWluLW9mZmxpbmUtcGVyLWNwdS1xdWFyYW50aW5lLnBhdGNo
DQo+ID4gPiANCj4gPiA+IFRoaXMgcGF0Y2ggd2FzIGRyb3BwZWQgYmVjYXVzZSBpdCB3YXMgbWVy
Z2VkIGludG8gbWFpbmxpbmUgb3IgYSBzdWJzeXN0ZW0gdHJlZQ0KPiA+ID4gDQo+ID4gDQo+ID4g
SGkgQW5kcmV3LA0KPiA+IA0KPiA+IFNvcnJ5IHRvIGJvdGhlci4NCj4gPiBUaGlzIHBhdGNoIGhh
cyBkZXBlbmRlbmN5IHdpdGggdHdvIHBhdGNoZXMgb2YgQW5kcmV5J3MgcGF0Y2ggc2VyaWVzIGFz
DQo+ID4gYmVsb3cuDQo+ID4gImthc2FuOiByZW5hbWUgZ2V0X2FsbG9jL2ZyZWVfaW5mbyINCj4g
PiAia2FzYW46IHNhbml0aXplIG9iamVjdHMgd2hlbiBtZXRhZGF0YSBkb2VzbnQgZml0Ig0KPiAN
Cj4gQXJlIHlvdSBzdXJlPyAgUGxlYXNlIGNoZWNrIDUuMTAgYW5kIGlmIHRoZXJlIGFyZSBwcm9i
bGVtcyB0aGVyZSwNCj4gcGxlYXNlIHByb3Bvc2UgYSBzdGFuZGFsb25lIGZpeC4NCj4gDQoNClll
cy4NCg0KQW5kcmV5J3MgcGF0Y2ggaGFzIHRoZSByZXR1cm4gdmFsdWUgYW5kIHJldHVybiBmYWxz
ZS4NClJldHVybiBmYWxzZSB3aWxsIG1ha2Ugc2xhYiBhbGxvY2F0b3IgZnJlZSB0aGUgb2JqZWN0
IGFuZCBxbGlua19mcmVlKCkNCmFsc28gZnJlZSB0aGUgb2JqZWN0LCBzbyBRaWFuZyByZW1vdmUg
dGhlIHFsaW5rX2ZyZWUoKSB0byByZXNvbHZlIHRoZQ0KZG91YmxlIGZyZWUgYXMgYmVsb3cuDQpo
dHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS8yMDIwMTIwNDEwMjIwNi4yMDIzNy0xLXFp
YW5nLnpoYW5nQHdpbmRyaXZlci5jb20vDQoNCiAJcSA9IHRoaXNfY3B1X3B0cigmY3B1X3F1YXJh
bnRpbmUpOw0KIAlpZiAocS0+b2ZmbGluZSkgew0KLQkJcWxpbmtfZnJlZSgmbWV0YS0+cXVhcmFu
dGluZV9saW5rLCBjYWNoZSk7IC8vIGZyZWUgb25jZQ0KIAkJbG9jYWxfaXJxX3Jlc3RvcmUoZmxh
Z3MpOw0KIAkJcmV0dXJuIGZhbHNlOyAgLy8gZnJlZSB0d2ljZQ0KIAl9DQoNCg0KQnV0IGlmIHJl
bW92aW5nIHFsaW5rX2ZyZWUoKSB3aXRob3V0IEFuZHJleSdzIHBhdGNoLCB0aGlzIA0Kb2JqZWN0
IHdpbGwgbm90IGJlIGZyZWVkLiBJdCB3aWxsIGNhdXNlIG1lbW9yeSBsZWFrIGFzIGJlbG93Lg0K
DQogCXEgPSB0aGlzX2NwdV9wdHIoJmNwdV9xdWFyYW50aW5lKTsNCiAJaWYgKHEtPm9mZmxpbmUp
IHsNCiAJCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsNCiAJCXJldHVybjsNCiAJfQ0KDQpUaHVz
LCBiZWZvcmUgYXBwbHlpbmcgQW5kcmV5J3MgcGF0Y2gsIHdlIHN0aWxsIG5lZWQgcWxpbmtfZnJl
ZSgpLg0KSSB3aWxsIHByZXBhcmUgYSBzdGFuZGFsb25lIGZpeCB0byBhZGQgcWxpbmtfZnJlZSgp
IGJhY2suDQoNClRoYW5rcy4NCg0K

