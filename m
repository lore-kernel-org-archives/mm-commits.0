Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1216FC636C9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 22:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32CD613D4
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 22:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhGOWjX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 18:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhGOWjW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 18:39:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B956A61158;
        Thu, 15 Jul 2021 22:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626388589;
        bh=6Z2dLTl/GApDoQCUCkICI8nhrJKTxeGAHGdZfOW2Ig8=;
        h=Date:From:To:Subject:From;
        b=fxdGnRjpD9uZXPIkweB8UEnX0jteBFDteFKEKpC1H/eM9f7x/jW576fPkb4VPg9gs
         6ImJmsu0HwRQ9JA6YrO02UzAUVPokbnZJGRJt6X3q33rVYpLacuTC6XFfUsWmfuwUe
         4k5NBo85W5CiaXGHgJgcC/pZQRp0OzdAcEbHxC5w=
Date:   Thu, 15 Jul 2021 15:36:28 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, lchen@suse.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  + ocfs2-remove-an-unnecessary-condition.patch added to
 -mm tree
Message-ID: <20210715223628.tkLaLEcVd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: application/octet-stream; charset=binary
Content-Transfer-Encoding: base64
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

ClRoZSBwYXRjaCB0aXRsZWQKICAgICBTdWJqZWN0OiBvY2ZzMjogcmVtb3ZlIGFuIHVubmVjZXNz
YXJ5IGNvbmRpdGlvbgpoYXMgYmVlbiBhZGRlZCB0byB0aGUgLW1tIHRyZWUuICBJdHMgZmlsZW5h
bWUgaXMKICAgICBvY2ZzMi1yZW1vdmUtYW4tdW5uZWNlc3NhcnktY29uZGl0aW9uLnBhdGNoCgpU
aGlzIHBhdGNoIHNob3VsZCBzb29uIGFwcGVhciBhdAogICAgaHR0cHM6Ly9vemxhYnMub3JnL35h
a3BtL21tb3RzL2Jyb2tlbi1vdXQvb2NmczItcmVtb3ZlLWFuLXVubmVjZXNzYXJ5LWNvbmRpdGlv
bi5wYXRjaAphbmQgbGF0ZXIgYXQKICAgIGh0dHBzOi8vb3psYWJzLm9yZy9+YWtwbS9tbW90bS9i
cm9rZW4tb3V0L29jZnMyLXJlbW92ZS1hbi11bm5lY2Vzc2FyeS1jb25kaXRpb24ucGF0Y2gKCkJl
Zm9yZSB5b3UganVzdCBnbyBhbmQgaGl0ICJyZXBseSIsIHBsZWFzZToKICAgYSkgQ29uc2lkZXIg
d2hvIGVsc2Ugc2hvdWxkIGJlIGNjJ2VkCiAgIGIpIFByZWZlciB0byBjYyBhIHN1aXRhYmxlIG1h
aWxpbmcgbGlzdCBhcyB3ZWxsCiAgIGMpIElkZWFsbHk6IGZpbmQgdGhlIG9yaWdpbmFsIHBhdGNo
IG9uIHRoZSBtYWlsaW5nIGxpc3QgYW5kIGRvIGEKICAgICAgcmVwbHktdG8tYWxsIHRvIHRoYXQs
IGFkZGluZyBzdWl0YWJsZSBhZGRpdGlvbmFsIGNjJ3MKCioqKiBSZW1lbWJlciB0byB1c2UgRG9j
dW1lbnRhdGlvbi9wcm9jZXNzL3N1Ym1pdC1jaGVja2xpc3QucnN0IHdoZW4gdGVzdGluZyB5b3Vy
IGNvZGUgKioqCgpUaGUgLW1tIHRyZWUgaXMgaW5jbHVkZWQgaW50byBsaW51eC1uZXh0IGFuZCBp
cyB1cGRhdGVkCnRoZXJlIGV2ZXJ5IDMtNCB3b3JraW5nIGRheXMKCi0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpGcm9tOiBEYW4gQ2FycGVudGVy
IDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+ClN1YmplY3Q6IG9jZnMyOiByZW1vdmUgYW4gdW5u
ZWNlc3NhcnkgY29uZGl0aW9uCgpUaGUgY2FzZSAQd2hlcmUgInRtcF9vaCIgaXMgTlVMTCBpcyBo
YW5kbGVkIGF0IHRoZSBzdGFydCBvZiB0aGUgZnVuY3Rpb24uCkF0IHRoaXMgcG9pbnQgd2Uga25v
dyBpdCdzIG5vbi1OVUxMIHNvIHRoaXMgd2lsbCBhbHdheXMgcmV0dXJuIDEuCgpMaW5rOiBodHRw
czovL2xrbWwua2VybmVsLm9yZy9yL1lPY0l0Z0lYdGlzaTNNYU9AbXdhbmRhClNpZ25lZC1vZmYt
Ynk6IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4KUmV2aWV3ZWQtYnk6
IEpvc2VwaCBRaSA8am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPgpDYzogTWFyayBGYXNoZWgg
PG1hcmtAZmFzaGVoLmNvbT4KQ2M6IEpvZWwgQmVja2VyIDxqbGJlY0BldmlscGxhbi5vcmc+CkNj
OiBKdW54aWFvIEJpIDxqdW54aWFvLmJpQG9yYWNsZS5jb20+CkNjOiBDaGFuZ3dlaSBHZSA8Z2Vj
aGFuZ3dlaUBsaXZlLmNuPgpDYzogR2FuZyBIZSA8Z2hlQHN1c2UuY29tPgpDYzogSnVuIFBpYW8g
PHBpYW9qdW5AaHVhd2VpLmNvbT4KQ2M6IExhcnJ5IENoZW4gPGxjaGVuQHN1c2UuY29tPgpTaWdu
ZWQtb2ZmLWJ5OiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgotLS0K
CiBmcy9vY2ZzMi9kbG1nbHVlLmMgfCAgICAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkKCi0tLSBhL2ZzL29jZnMyL2RsbWdsdWUuY35vY2ZzMi1yZW1v
dmUtYW4tdW5uZWNlc3NhcnktY29uZGl0aW9uCisrKyBhL2ZzL29jZnMyL2RsbWdsdWUuYwpAQCAt
MjcyMSw3ICsyNzIxLDcgQEAgaW50IG9jZnMyX2lub2RlX2xvY2tfdHJhY2tlcihzdHJ1Y3QgaW5v
ZAogCQkJcmV0dXJuIHN0YXR1czsKIAkJfQogCX0KLQlyZXR1cm4gdG1wX29oID8gMSA6IDA7CisJ
cmV0dXJuIDE7CiB9CiAKIHZvaWQgb2NmczJfaW5vZGVfdW5sb2NrX3RyYWNrZXIoc3RydWN0IGlu
b2RlICppbm9kZSwKXwoKUGF0Y2hlcyBjdXJyZW50bHkgaW4gLW1tIHdoaWNoIG1pZ2h0IGJlIGZy
b20gZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tIGFyZQoKb2NmczItcmVtb3ZlLWFuLXVubmVjZXNz
YXJ5LWNvbmRpdGlvbi5wYXRjaAoK
