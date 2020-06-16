From: akpm@linux-foundation.org
Subject: + mm-treewide-rename-kzfree-to-kfree_sensitive.patch added
 to -mm tree
Date: Tue, 16 Jun 2020 11:09:59 -0700
Message-ID: <20200616180959.8hqqc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729815AbgFPSKF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 14:10:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@infradead.org, serge@hallyn.com, rientjes@google.com, mhocko@suse.com, joe@perches.com, jmorris@namei.org, Jason@zx2c4.com, jarkko.sakkinen@linux.intel.com, hannes@cmpxchg.org, dhowells@redhat.com, dan.carpenter@oracle.com, longman@redhat.com


The patch titled
     Subject: mm, treewide: rename kzfree() to kfree_sensitive()
has been added to the -mm tree.  Its filename is
     mm-treewide-rename-kzfree-to-kfree_sensitive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-treewide-rename-kzfree-to-k=
free_sensitive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-treewide-rename-kzfree-to-k=
free_sensitive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm, treewide: rename kzfree() to kfree_sensitive()

As said by Linus:

  A symmetric naming is only helpful if it implies symmetries in use.
  Otherwise it's actively misleading.

  In "kzalloc()", the z is meaningful and an important part of what the
  caller wants.

  In "kzfree()", the z is actively detrimental, because maybe in the
  future we really _might_ want to use that "memfill(0xdeadbeef)" or
  something. The "zero" part of the interface isn't even _relevant_.

The main reason that kzfree() exists is to clear sensitive information
that should not be leaked to other future users of the same memory
objects.

Rename kzfree() to kfree_sensitive() to follow the example of the recently
added kvfree_sensitive() and make the intention of the API more explicit.=
=20
In addition, memzero_explicit() is used to clear the memory to make sure
that it won't get optimized away by the compiler.

The renaming is done by using the command sequence:

  git grep -w --name-only kzfree |\
  xargs sed -i 's/=08kzfree=08/kfree_sensitive/'

followed by some editing of the kfree_sensitive() kerneldoc and adding
a kzfree backward compatibility macro in slab.h.

Link: http://lkml.kernel.org/r/20200616154311.12314-3-longman@redhat.com
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Joe Perches <joe@perches.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/crypto/prng.c                                |    4 -
 arch/x86/power/hibernate.c                             |    2=20
 crypto/adiantum.c                                      |    2=20
 crypto/ahash.c                                         |    4 -
 crypto/api.c                                           |    2=20
 crypto/asymmetric_keys/verify_pefile.c                 |    4 -
 crypto/deflate.c                                       |    2=20
 crypto/drbg.c                                          |   10 +-
 crypto/ecc.c                                           |    8 +-
 crypto/ecdh.c                                          |    2=20
 crypto/gcm.c                                           |    2=20
 crypto/gf128mul.c                                      |    4 -
 crypto/jitterentropy-kcapi.c                           |    2=20
 crypto/rng.c                                           |    2=20
 crypto/rsa-pkcs1pad.c                                  |    6 -
 crypto/seqiv.c                                         |    2=20
 crypto/shash.c                                         |    2=20
 crypto/skcipher.c                                      |    2=20
 crypto/testmgr.c                                       |    6 -
 crypto/zstd.c                                          |    2=20
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |    2=20
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |    2=20
 drivers/crypto/amlogic/amlogic-gxl-cipher.c            |    4 -
 drivers/crypto/atmel-ecc.c                             |    2=20
 drivers/crypto/caam/caampkc.c                          |   28 ++++----
 drivers/crypto/cavium/cpt/cptvf_main.c                 |    6 -
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c           |   12 +--
 drivers/crypto/cavium/nitrox/nitrox_lib.c              |    4 -
 drivers/crypto/cavium/zip/zip_crypto.c                 |    6 -
 drivers/crypto/ccp/ccp-crypto-rsa.c                    |    6 -
 drivers/crypto/ccree/cc_aead.c                         |    4 -
 drivers/crypto/ccree/cc_buffer_mgr.c                   |    4 -
 drivers/crypto/ccree/cc_cipher.c                       |    6 -
 drivers/crypto/ccree/cc_hash.c                         |    8 +-
 drivers/crypto/ccree/cc_request_mgr.c                  |    2=20
 drivers/crypto/marvell/cesa/hash.c                     |    2=20
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c       |    6 -
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h     |    2=20
 drivers/crypto/mediatek/mtk-aes.c                      |    2=20
 drivers/crypto/nx/nx.c                                 |    4 -
 drivers/crypto/virtio/virtio_crypto_algs.c             |   12 +--
 drivers/crypto/virtio/virtio_crypto_core.c             |    2=20
 drivers/md/dm-crypt.c                                  |   32 ++++-----
 drivers/md/dm-integrity.c                              |    6 -
 drivers/misc/ibmvmc.c                                  |    6 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c         |    6 -
 drivers/net/ppp/ppp_mppe.c                             |    6 -
 drivers/net/wireguard/noise.c                          |    4 -
 drivers/net/wireguard/peer.c                           |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c           |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c      |    6 -
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c           |    6 -
 drivers/net/wireless/intersil/orinoco/wext.c           |    4 -
 drivers/s390/crypto/ap_bus.h                           |    4 -
 drivers/staging/ks7010/ks_hostif.c                     |    2=20
 drivers/staging/rtl8723bs/core/rtw_security.c          |    2=20
 drivers/staging/wlan-ng/p80211netdev.c                 |    2=20
 drivers/target/iscsi/iscsi_target_auth.c               |    2=20
 fs/cifs/cifsencrypt.c                                  |    2=20
 fs/cifs/connect.c                                      |   10 +-
 fs/cifs/dfs_cache.c                                    |    2=20
 fs/cifs/misc.c                                         |    8 +-
 fs/crypto/keyring.c                                    |    6 -
 fs/crypto/keysetup_v1.c                                |    4 -
 fs/ecryptfs/keystore.c                                 |    4 -
 fs/ecryptfs/messaging.c                                |    2=20
 include/crypto/aead.h                                  |    2=20
 include/crypto/akcipher.h                              |    2=20
 include/crypto/gf128mul.h                              |    2=20
 include/crypto/hash.h                                  |    2=20
 include/crypto/internal/acompress.h                    |    2=20
 include/crypto/kpp.h                                   |    2=20
 include/crypto/skcipher.h                              |    2=20
 include/linux/slab.h                                   |    4 -
 lib/mpi/mpiutil.c                                      |    6 -
 lib/test_kasan.c                                       |    6 -
 mm/slab_common.c                                       |    8 +-
 net/atm/mpoa_caches.c                                  |    4 -
 net/bluetooth/ecdh_helper.c                            |    6 -
 net/bluetooth/smp.c                                    |   24 +++----
 net/core/sock.c                                        |    2=20
 net/ipv4/tcp_fastopen.c                                |    2=20
 net/mac80211/aead_api.c                                |    4 -
 net/mac80211/aes_gmac.c                                |    2=20
 net/mac80211/key.c                                     |    2=20
 net/mac802154/llsec.c                                  |   20 ++---
 net/sctp/auth.c                                        |    2=20
 net/sctp/socket.c                                      |    2=20
 net/sunrpc/auth_gss/gss_krb5_crypto.c                  |    4 -
 net/sunrpc/auth_gss/gss_krb5_keys.c                    |    6 -
 net/sunrpc/auth_gss/gss_krb5_mech.c                    |    2=20
 net/tipc/crypto.c                                      |   10 +-
 net/wireless/core.c                                    |    2=20
 net/wireless/ibss.c                                    |    4 -
 net/wireless/lib80211_crypt_tkip.c                     |    2=20
 net/wireless/lib80211_crypt_wep.c                      |    2=20
 net/wireless/nl80211.c                                 |   24 +++----
 net/wireless/sme.c                                     |    6 -
 net/wireless/util.c                                    |    2=20
 net/wireless/wext-sme.c                                |    2=20
 scripts/coccinelle/free/devm_free.cocci                |    4 -
 scripts/coccinelle/free/ifnullfree.cocci               |    4 -
 scripts/coccinelle/free/kfree.cocci                    |    6 -
 scripts/coccinelle/free/kfreeaddr.cocci                |    2=20
 security/apparmor/domain.c                             |    4 -
 security/apparmor/include/file.h                       |    2=20
 security/apparmor/policy.c                             |   24 +++----
 security/apparmor/policy_ns.c                          |    6 -
 security/apparmor/policy_unpack.c                      |   14 ++--
 security/keys/big_key.c                                |    6 -
 security/keys/dh.c                                     |   14 ++--
 security/keys/encrypted-keys/encrypted.c               |   14 ++--
 security/keys/trusted-keys/trusted_tpm1.c              |   34 +++++-----
 security/keys/user_defined.c                           |    6 -
 115 files changed, 322 insertions(+), 320 deletions(-)

--- a/arch/s390/crypto/prng.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/arch/s390/crypto/prng.c
@@ -249,7 +249,7 @@ static void prng_tdes_deinstantiate(void
 {
 	pr_debug("The prng module stopped "
 		 "after running in triple DES mode\n");
-	kzfree(prng_data);
+	kfree_sensitive(prng_data);
 }
=20
=20
@@ -442,7 +442,7 @@ outfree:
 static void prng_sha512_deinstantiate(void)
 {
 	pr_debug("The prng module stopped after running in SHA-512 mode\n");
-	kzfree(prng_data);
+	kfree_sensitive(prng_data);
 }
=20
=20
--- a/arch/x86/power/hibernate.c~mm-treewide-rename-kzfree-to-kfree_sensiti=
ve
+++ a/arch/x86/power/hibernate.c
@@ -98,7 +98,7 @@ static int get_e820_md5(struct e820_tabl
 	if (crypto_shash_digest(desc, (u8 *)table, size, buf))
 		ret =3D -EINVAL;
=20
-	kzfree(desc);
+	kfree_sensitive(desc);
=20
 free_tfm:
 	crypto_free_shash(tfm);
--- a/crypto/adiantum.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/adiantum.c
@@ -177,7 +177,7 @@ static int adiantum_setkey(struct crypto
 	keyp +=3D NHPOLY1305_KEY_SIZE;
 	WARN_ON(keyp !=3D &data->derived_keys[ARRAY_SIZE(data->derived_keys)]);
 out:
-	kzfree(data);
+	kfree_sensitive(data);
 	return err;
 }
=20
--- a/crypto/ahash.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/ahash.c
@@ -183,7 +183,7 @@ static int ahash_setkey_unaligned(struct
 	alignbuffer =3D (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret =3D tfm->setkey(tfm, alignbuffer, keylen);
-	kzfree(buffer);
+	kfree_sensitive(buffer);
 	return ret;
 }
=20
@@ -302,7 +302,7 @@ static void ahash_restore_req(struct aha
 	req->priv =3D NULL;
=20
 	/* Free the req->priv.priv from the ADJUSTED request. */
-	kzfree(priv);
+	kfree_sensitive(priv);
 }
=20
 static void ahash_notify_einprogress(struct ahash_request *req)
--- a/crypto/api.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/api.c
@@ -565,7 +565,7 @@ void crypto_destroy_tfm(void *mem, struc
 		alg->cra_exit(tfm);
 	crypto_exit_ops(tfm);
 	crypto_mod_put(alg);
-	kzfree(mem);
+	kfree_sensitive(mem);
 }
 EXPORT_SYMBOL_GPL(crypto_destroy_tfm);
=20
--- a/crypto/asymmetric_keys/verify_pefile.c~mm-treewide-rename-kzfree-to-k=
free_sensitive
+++ a/crypto/asymmetric_keys/verify_pefile.c
@@ -376,7 +376,7 @@ static int pefile_digest_pe(const void *
 	}
=20
 error:
-	kzfree(desc);
+	kfree_sensitive(desc);
 error_no_desc:
 	crypto_free_shash(tfm);
 	kleave(" =3D %d", ret);
@@ -447,6 +447,6 @@ int verify_pefile_signature(const void *
 	ret =3D pefile_digest_pe(pebuf, pelen, &ctx);
=20
 error:
-	kzfree(ctx.digest);
+	kfree_sensitive(ctx.digest);
 	return ret;
 }
--- a/crypto/deflate.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/deflate.c
@@ -163,7 +163,7 @@ static void __deflate_exit(void *ctx)
 static void deflate_free_ctx(struct crypto_scomp *tfm, void *ctx)
 {
 	__deflate_exit(ctx);
-	kzfree(ctx);
+	kfree_sensitive(ctx);
 }
=20
 static void deflate_exit(struct crypto_tfm *tfm)
--- a/crypto/drbg.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/drbg.c
@@ -1218,19 +1218,19 @@ static inline void drbg_dealloc_state(st
 {
 	if (!drbg)
 		return;
-	kzfree(drbg->Vbuf);
+	kfree_sensitive(drbg->Vbuf);
 	drbg->Vbuf =3D NULL;
 	drbg->V =3D NULL;
-	kzfree(drbg->Cbuf);
+	kfree_sensitive(drbg->Cbuf);
 	drbg->Cbuf =3D NULL;
 	drbg->C =3D NULL;
-	kzfree(drbg->scratchpadbuf);
+	kfree_sensitive(drbg->scratchpadbuf);
 	drbg->scratchpadbuf =3D NULL;
 	drbg->reseed_ctr =3D 0;
 	drbg->d_ops =3D NULL;
 	drbg->core =3D NULL;
 	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
-		kzfree(drbg->prev);
+		kfree_sensitive(drbg->prev);
 		drbg->prev =3D NULL;
 		drbg->fips_primed =3D false;
 	}
@@ -1699,7 +1699,7 @@ static int drbg_fini_hash_kernel(struct
 	struct sdesc *sdesc =3D (struct sdesc *)drbg->priv_data;
 	if (sdesc) {
 		crypto_free_shash(sdesc->shash.tfm);
-		kzfree(sdesc);
+		kfree_sensitive(sdesc);
 	}
 	drbg->priv_data =3D NULL;
 	return 0;
--- a/crypto/ecc.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/ecc.c
@@ -67,7 +67,7 @@ static u64 *ecc_alloc_digits_space(unsig
=20
 static void ecc_free_digits_space(u64 *space)
 {
-	kzfree(space);
+	kfree_sensitive(space);
 }
=20
 static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
@@ -101,9 +101,9 @@ static void ecc_free_point(struct ecc_po
 	if (!p)
 		return;
=20
-	kzfree(p->x);
-	kzfree(p->y);
-	kzfree(p);
+	kfree_sensitive(p->x);
+	kfree_sensitive(p->y);
+	kfree_sensitive(p);
 }
=20
 static void vli_clear(u64 *vli, unsigned int ndigits)
--- a/crypto/ecdh.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/ecdh.c
@@ -124,7 +124,7 @@ static int ecdh_compute_value(struct kpp
=20
 	/* fall through */
 free_all:
-	kzfree(shared_secret);
+	kfree_sensitive(shared_secret);
 free_pubkey:
 	kfree(public_key);
 	return ret;
--- a/crypto/gcm.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/gcm.c
@@ -139,7 +139,7 @@ static int crypto_gcm_setkey(struct cryp
 			       CRYPTO_TFM_REQ_MASK);
 	err =3D crypto_ahash_setkey(ghash, (u8 *)&data->hash, sizeof(be128));
 out:
-	kzfree(data);
+	kfree_sensitive(data);
 	return err;
 }
=20
--- a/crypto/gf128mul.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/gf128mul.c
@@ -304,8 +304,8 @@ void gf128mul_free_64k(struct gf128mul_6
 	int i;
=20
 	for (i =3D 0; i < 16; i++)
-		kzfree(t->t[i]);
-	kzfree(t);
+		kfree_sensitive(t->t[i]);
+	kfree_sensitive(t);
 }
 EXPORT_SYMBOL(gf128mul_free_64k);
=20
--- a/crypto/jitterentropy-kcapi.c~mm-treewide-rename-kzfree-to-kfree_sensi=
tive
+++ a/crypto/jitterentropy-kcapi.c
@@ -57,7 +57,7 @@ void *jent_zalloc(unsigned int len)
=20
 void jent_zfree(void *ptr)
 {
-	kzfree(ptr);
+	kfree_sensitive(ptr);
 }
=20
 int jent_fips_enabled(void)
--- a/crypto/rng.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/rng.c
@@ -53,7 +53,7 @@ int crypto_rng_reset(struct crypto_rng *
 	err =3D crypto_rng_alg(tfm)->seed(tfm, seed, slen);
 	crypto_stats_rng_seed(alg, err);
 out:
-	kzfree(buf);
+	kfree_sensitive(buf);
 	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_rng_reset);
--- a/crypto/rsa-pkcs1pad.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/rsa-pkcs1pad.c
@@ -199,7 +199,7 @@ static int pkcs1pad_encrypt_sign_complet
 	sg_copy_from_buffer(req->dst,
 			    sg_nents_for_len(req->dst, ctx->key_size),
 			    out_buf, ctx->key_size);
-	kzfree(out_buf);
+	kfree_sensitive(out_buf);
=20
 out:
 	req->dst_len =3D ctx->key_size;
@@ -322,7 +322,7 @@ static int pkcs1pad_decrypt_complete(str
 				out_buf + pos, req->dst_len);
=20
 done:
-	kzfree(req_ctx->out_buf);
+	kfree_sensitive(req_ctx->out_buf);
=20
 	return err;
 }
@@ -500,7 +500,7 @@ static int pkcs1pad_verify_complete(stru
 		   req->dst_len) !=3D 0)
 		err =3D -EKEYREJECTED;
 done:
-	kzfree(req_ctx->out_buf);
+	kfree_sensitive(req_ctx->out_buf);
=20
 	return err;
 }
--- a/crypto/seqiv.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/seqiv.c
@@ -33,7 +33,7 @@ static void seqiv_aead_encrypt_complete2
 	memcpy(req->iv, subreq->iv, crypto_aead_ivsize(geniv));
=20
 out:
-	kzfree(subreq->iv);
+	kfree_sensitive(subreq->iv);
 }
=20
 static void seqiv_aead_encrypt_complete(struct crypto_async_request *base,
--- a/crypto/shash.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/shash.c
@@ -44,7 +44,7 @@ static int shash_setkey_unaligned(struct
 	alignbuffer =3D (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	err =3D shash->setkey(tfm, alignbuffer, keylen);
-	kzfree(buffer);
+	kfree_sensitive(buffer);
 	return err;
 }
=20
--- a/crypto/skcipher.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/skcipher.c
@@ -592,7 +592,7 @@ static int skcipher_setkey_unaligned(str
 	alignbuffer =3D (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret =3D cipher->setkey(tfm, alignbuffer, keylen);
-	kzfree(buffer);
+	kfree_sensitive(buffer);
 	return ret;
 }
=20
--- a/crypto/testmgr.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/testmgr.c
@@ -1744,7 +1744,7 @@ out:
 	kfree(vec.plaintext);
 	kfree(vec.digest);
 	crypto_free_shash(generic_tfm);
-	kzfree(generic_desc);
+	kfree_sensitive(generic_desc);
 	return err;
 }
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
@@ -3665,7 +3665,7 @@ static int drbg_cavs_test(const struct d
 	if (IS_ERR(drng)) {
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
-		kzfree(buf);
+		kfree_sensitive(buf);
 		return -ENOMEM;
 	}
=20
@@ -3712,7 +3712,7 @@ static int drbg_cavs_test(const struct d
=20
 outbuf:
 	crypto_free_rng(drng);
-	kzfree(buf);
+	kfree_sensitive(buf);
 	return ret;
 }
=20
--- a/crypto/zstd.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/crypto/zstd.c
@@ -137,7 +137,7 @@ static void __zstd_exit(void *ctx)
 static void zstd_free_ctx(struct crypto_scomp *tfm, void *ctx)
 {
 	__zstd_exit(ctx);
-	kzfree(ctx);
+	kfree_sensitive(ctx);
 }
=20
 static void zstd_exit(struct crypto_tfm *tfm)
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c~mm-treewide-renam=
e-kzfree-to-kfree_sensitive
+++ a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -257,7 +257,7 @@ theend_iv:
 		offset =3D areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
 			memcpy(areq->iv, backup_iv, ivsize);
-			kzfree(backup_iv);
+			kfree_sensitive(backup_iv);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c~mm-treewide-renam=
e-kzfree-to-kfree_sensitive
+++ a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -250,7 +250,7 @@ theend_iv:
 			if (rctx->op_dir & SS_DECRYPTION) {
 				memcpy(areq->iv, backup_iv, ivsize);
 				memzero_explicit(backup_iv, ivsize);
-				kzfree(backup_iv);
+				kfree_sensitive(backup_iv);
 			} else {
 				scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 							 ivsize, 0);
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c~mm-treewide-rename-kzfree=
-to-kfree_sensitive
+++ a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -254,8 +254,8 @@ static int meson_cipher(struct skcipher_
 		}
 	}
 theend:
-	kzfree(bkeyiv);
-	kzfree(backup_iv);
+	kfree_sensitive(bkeyiv);
+	kfree_sensitive(backup_iv);
=20
 	return err;
 }
--- a/drivers/crypto/atmel-ecc.c~mm-treewide-rename-kzfree-to-kfree_sensiti=
ve
+++ a/drivers/crypto/atmel-ecc.c
@@ -69,7 +69,7 @@ static void atmel_ecdh_done(struct atmel
=20
 	/* fall through */
 free_work_data:
-	kzfree(work_data);
+	kfree_sensitive(work_data);
 	kpp_request_complete(req, status);
 }
=20
--- a/drivers/crypto/caam/caampkc.c~mm-treewide-rename-kzfree-to-kfree_sens=
itive
+++ a/drivers/crypto/caam/caampkc.c
@@ -854,14 +854,14 @@ static int caam_rsa_dec(struct akcipher_
=20
 static void caam_rsa_free_key(struct caam_rsa_key *key)
 {
-	kzfree(key->d);
-	kzfree(key->p);
-	kzfree(key->q);
-	kzfree(key->dp);
-	kzfree(key->dq);
-	kzfree(key->qinv);
-	kzfree(key->tmp1);
-	kzfree(key->tmp2);
+	kfree_sensitive(key->d);
+	kfree_sensitive(key->p);
+	kfree_sensitive(key->q);
+	kfree_sensitive(key->dp);
+	kfree_sensitive(key->dq);
+	kfree_sensitive(key->qinv);
+	kfree_sensitive(key->tmp1);
+	kfree_sensitive(key->tmp2);
 	kfree(key->e);
 	kfree(key->n);
 	memset(key, 0, sizeof(*key));
@@ -1018,17 +1018,17 @@ static void caam_rsa_set_priv_key_form(s
 	return;
=20
 free_dq:
-	kzfree(rsa_key->dq);
+	kfree_sensitive(rsa_key->dq);
 free_dp:
-	kzfree(rsa_key->dp);
+	kfree_sensitive(rsa_key->dp);
 free_tmp2:
-	kzfree(rsa_key->tmp2);
+	kfree_sensitive(rsa_key->tmp2);
 free_tmp1:
-	kzfree(rsa_key->tmp1);
+	kfree_sensitive(rsa_key->tmp1);
 free_q:
-	kzfree(rsa_key->q);
+	kfree_sensitive(rsa_key->q);
 free_p:
-	kzfree(rsa_key->p);
+	kfree_sensitive(rsa_key->p);
 }
=20
 static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *=
key,
--- a/drivers/crypto/cavium/cpt/cptvf_main.c~mm-treewide-rename-kzfree-to-k=
free_sensitive
+++ a/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -74,7 +74,7 @@ static void cleanup_worker_threads(struc
 	for (i =3D 0; i < cptvf->nr_queues; i++)
 		tasklet_kill(&cwqe_info->vq_wqe[i].twork);
=20
-	kzfree(cwqe_info);
+	kfree_sensitive(cwqe_info);
 	cptvf->wqe_info =3D NULL;
 }
=20
@@ -88,7 +88,7 @@ static void free_pending_queues(struct p
 			continue;
=20
 		/* free single queue */
-		kzfree((queue->head));
+		kfree_sensitive((queue->head));
=20
 		queue->front =3D 0;
 		queue->rear =3D 0;
@@ -189,7 +189,7 @@ static void free_command_queues(struct c
 			chunk->head =3D NULL;
 			chunk->dma_addr =3D 0;
 			hlist_del(&chunk->nextchunk);
-			kzfree(chunk);
+			kfree_sensitive(chunk);
 		}
=20
 		queue->nchunks =3D 0;
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c~mm-treewide-rename-kzfre=
e-to-kfree_sensitive
+++ a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -305,12 +305,12 @@ static void do_request_cleanup(struct cp
 		}
 	}
=20
-	kzfree(info->scatter_components);
-	kzfree(info->gather_components);
-	kzfree(info->out_buffer);
-	kzfree(info->in_buffer);
-	kzfree((void *)info->completion_addr);
-	kzfree(info);
+	kfree_sensitive(info->scatter_components);
+	kfree_sensitive(info->gather_components);
+	kfree_sensitive(info->out_buffer);
+	kfree_sensitive(info->in_buffer);
+	kfree_sensitive((void *)info->completion_addr);
+	kfree_sensitive(info);
 }
=20
 static void do_post_process(struct cpt_vf *cptvf, struct cpt_info_buffer *=
info)
--- a/drivers/crypto/cavium/nitrox/nitrox_lib.c~mm-treewide-rename-kzfree-t=
o-kfree_sensitive
+++ a/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -90,7 +90,7 @@ static void nitrox_free_aqm_queues(struc
=20
 	for (i =3D 0; i < ndev->nr_queues; i++) {
 		nitrox_cmdq_cleanup(ndev->aqmq[i]);
-		kzfree(ndev->aqmq[i]);
+		kfree_sensitive(ndev->aqmq[i]);
 		ndev->aqmq[i] =3D NULL;
 	}
 }
@@ -122,7 +122,7 @@ static int nitrox_alloc_aqm_queues(struc
=20
 		err =3D nitrox_cmdq_init(cmdq, AQM_Q_ALIGN_BYTES);
 		if (err) {
-			kzfree(cmdq);
+			kfree_sensitive(cmdq);
 			goto aqmq_fail;
 		}
 		ndev->aqmq[i] =3D cmdq;
--- a/drivers/crypto/cavium/zip/zip_crypto.c~mm-treewide-rename-kzfree-to-k=
free_sensitive
+++ a/drivers/crypto/cavium/zip/zip_crypto.c
@@ -260,7 +260,7 @@ void *zip_alloc_scomp_ctx_deflate(struct
 	ret =3D zip_ctx_init(zip_ctx, 0);
=20
 	if (ret) {
-		kzfree(zip_ctx);
+		kfree_sensitive(zip_ctx);
 		return ERR_PTR(ret);
 	}
=20
@@ -279,7 +279,7 @@ void *zip_alloc_scomp_ctx_lzs(struct cry
 	ret =3D zip_ctx_init(zip_ctx, 1);
=20
 	if (ret) {
-		kzfree(zip_ctx);
+		kfree_sensitive(zip_ctx);
 		return ERR_PTR(ret);
 	}
=20
@@ -291,7 +291,7 @@ void zip_free_scomp_ctx(struct crypto_sc
 	struct zip_kernel_ctx *zip_ctx =3D ctx;
=20
 	zip_ctx_exit(zip_ctx);
-	kzfree(zip_ctx);
+	kfree_sensitive(zip_ctx);
 }
=20
 int zip_scomp_compress(struct crypto_scomp *tfm,
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c~mm-treewide-rename-kzfree-to-kfre=
e_sensitive
+++ a/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -112,13 +112,13 @@ static int ccp_check_key_length(unsigned
 static void ccp_rsa_free_key_bufs(struct ccp_ctx *ctx)
 {
 	/* Clean up old key data */
-	kzfree(ctx->u.rsa.e_buf);
+	kfree_sensitive(ctx->u.rsa.e_buf);
 	ctx->u.rsa.e_buf =3D NULL;
 	ctx->u.rsa.e_len =3D 0;
-	kzfree(ctx->u.rsa.n_buf);
+	kfree_sensitive(ctx->u.rsa.n_buf);
 	ctx->u.rsa.n_buf =3D NULL;
 	ctx->u.rsa.n_len =3D 0;
-	kzfree(ctx->u.rsa.d_buf);
+	kfree_sensitive(ctx->u.rsa.d_buf);
 	ctx->u.rsa.d_buf =3D NULL;
 	ctx->u.rsa.d_len =3D 0;
 }
--- a/drivers/crypto/ccree/cc_aead.c~mm-treewide-rename-kzfree-to-kfree_sen=
sitive
+++ a/drivers/crypto/ccree/cc_aead.c
@@ -448,7 +448,7 @@ static int cc_get_plain_hmac_key(struct
 		if (dma_mapping_error(dev, key_dma_addr)) {
 			dev_err(dev, "Mapping key va=3D0x%p len=3D%u for DMA failed\n",
 				key, keylen);
-			kzfree(key);
+			kfree_sensitive(key);
 			return -ENOMEM;
 		}
 		if (keylen > blocksize) {
@@ -533,7 +533,7 @@ static int cc_get_plain_hmac_key(struct
 	if (key_dma_addr)
 		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
=20
-	kzfree(key);
+	kfree_sensitive(key);
=20
 	return rc;
 }
--- a/drivers/crypto/ccree/cc_buffer_mgr.c~mm-treewide-rename-kzfree-to-kfr=
ee_sensitive
+++ a/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -488,7 +488,7 @@ void cc_unmap_aead_request(struct device
 	if (areq_ctx->gen_ctx.iv_dma_addr) {
 		dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
 				 hw_iv_size, DMA_BIDIRECTIONAL);
-		kzfree(areq_ctx->gen_ctx.iv);
+		kfree_sensitive(areq_ctx->gen_ctx.iv);
 	}
=20
 	/* Release pool */
@@ -559,7 +559,7 @@ static int cc_aead_chain_iv(struct cc_dr
 	if (dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr)) {
 		dev_err(dev, "Mapping iv %u B at va=3D%pK for DMA failed\n",
 			hw_iv_size, req->iv);
-		kzfree(areq_ctx->gen_ctx.iv);
+		kfree_sensitive(areq_ctx->gen_ctx.iv);
 		areq_ctx->gen_ctx.iv =3D NULL;
 		rc =3D -ENOMEM;
 		goto chain_iv_exit;
--- a/drivers/crypto/ccree/cc_cipher.c~mm-treewide-rename-kzfree-to-kfree_s=
ensitive
+++ a/drivers/crypto/ccree/cc_cipher.c
@@ -229,7 +229,7 @@ static void cc_cipher_exit(struct crypto
 		&ctx_p->user.key_dma_addr);
=20
 	/* Free key buffer in context */
-	kzfree(ctx_p->user.key);
+	kfree_sensitive(ctx_p->user.key);
 	dev_dbg(dev, "Free key buffer in context. key=3D@%p\n", ctx_p->user.key);
 }
=20
@@ -825,7 +825,7 @@ static void cc_cipher_complete(struct de
 		/* Not a BACKLOG notification */
 		cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
 		memcpy(req->iv, req_ctx->iv, ivsize);
-		kzfree(req_ctx->iv);
+		kfree_sensitive(req_ctx->iv);
 	}
=20
 	skcipher_request_complete(req, err);
@@ -927,7 +927,7 @@ static int cc_cipher_process(struct skci
=20
 exit_process:
 	if (rc !=3D -EINPROGRESS && rc !=3D -EBUSY) {
-		kzfree(req_ctx->iv);
+		kfree_sensitive(req_ctx->iv);
 	}
=20
 	return rc;
--- a/drivers/crypto/ccree/cc_hash.c~mm-treewide-rename-kzfree-to-kfree_sen=
sitive
+++ a/drivers/crypto/ccree/cc_hash.c
@@ -764,7 +764,7 @@ static int cc_hash_setkey(struct crypto_
 		if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 			dev_err(dev, "Mapping key va=3D0x%p len=3D%u for DMA failed\n",
 				ctx->key_params.key, keylen);
-			kzfree(ctx->key_params.key);
+			kfree_sensitive(ctx->key_params.key);
 			return -ENOMEM;
 		}
 		dev_dbg(dev, "mapping key-buffer: key_dma_addr=3D%pad keylen=3D%u\n",
@@ -913,7 +913,7 @@ out:
 			&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 	}
=20
-	kzfree(ctx->key_params.key);
+	kfree_sensitive(ctx->key_params.key);
=20
 	return rc;
 }
@@ -950,7 +950,7 @@ static int cc_xcbc_setkey(struct crypto_
 	if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 		dev_err(dev, "Mapping key va=3D0x%p len=3D%u for DMA failed\n",
 			key, keylen);
-		kzfree(ctx->key_params.key);
+		kfree_sensitive(ctx->key_params.key);
 		return -ENOMEM;
 	}
 	dev_dbg(dev, "mapping key-buffer: key_dma_addr=3D%pad keylen=3D%u\n",
@@ -999,7 +999,7 @@ static int cc_xcbc_setkey(struct crypto_
 	dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=3D%pad keylen=3D%u\n",
 		&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
=20
-	kzfree(ctx->key_params.key);
+	kfree_sensitive(ctx->key_params.key);
=20
 	return rc;
 }
--- a/drivers/crypto/ccree/cc_request_mgr.c~mm-treewide-rename-kzfree-to-kf=
ree_sensitive
+++ a/drivers/crypto/ccree/cc_request_mgr.c
@@ -107,7 +107,7 @@ void cc_req_mgr_fini(struct cc_drvdata *
 	/* Kill tasklet */
 	tasklet_kill(&req_mgr_h->comptask);
 #endif
-	kzfree(req_mgr_h);
+	kfree_sensitive(req_mgr_h);
 	drvdata->request_mgr_handle =3D NULL;
 }
=20
--- a/drivers/crypto/marvell/cesa/hash.c~mm-treewide-rename-kzfree-to-kfree=
_sensitive
+++ a/drivers/crypto/marvell/cesa/hash.c
@@ -1154,7 +1154,7 @@ static int mv_cesa_ahmac_pad_init(struct
 		}
=20
 		/* Set the memory region to 0 to avoid any leak. */
-		kzfree(keydup);
+		kfree_sensitive(keydup);
=20
 		if (ret)
 			return ret;
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c~mm-treewide-rename-k=
zfree-to-kfree_sensitive
+++ a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -68,7 +68,7 @@ static void cleanup_worker_threads(struc
 	for (i =3D 0; i < cptvf->num_queues; i++)
 		tasklet_kill(&cwqe_info->vq_wqe[i].twork);
=20
-	kzfree(cwqe_info);
+	kfree_sensitive(cwqe_info);
 	cptvf->wqe_info =3D NULL;
 }
=20
@@ -82,7 +82,7 @@ static void free_pending_queues(struct o
 			continue;
=20
 		/* free single queue */
-		kzfree((queue->head));
+		kfree_sensitive((queue->head));
 		queue->front =3D 0;
 		queue->rear =3D 0;
 		queue->qlen =3D 0;
@@ -176,7 +176,7 @@ static void free_command_queues(struct o
 			chunk->head =3D NULL;
 			chunk->dma_addr =3D 0;
 			list_del(&chunk->nextchunk);
-			kzfree(chunk);
+			kfree_sensitive(chunk);
 		}
 		queue->num_chunks =3D 0;
 		queue->idx =3D 0;
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h~mm-treewide-rename=
-kzfree-to-kfree_sensitive
+++ a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h
@@ -215,7 +215,7 @@ static inline void do_request_cleanup(st
 						 DMA_BIDIRECTIONAL);
 		}
 	}
-	kzfree(info);
+	kfree_sensitive(info);
 }
=20
 struct otx_cptvf_wqe;
--- a/drivers/crypto/mediatek/mtk-aes.c~mm-treewide-rename-kzfree-to-kfree_=
sensitive
+++ a/drivers/crypto/mediatek/mtk-aes.c
@@ -1057,7 +1057,7 @@ static int mtk_aes_gcm_setkey(struct cry
 	mtk_aes_write_state_be(ctx->key + ctx->keylen, data->hash,
 			       AES_BLOCK_SIZE);
 out:
-	kzfree(data);
+	kfree_sensitive(data);
 	return err;
 }
=20
--- a/drivers/crypto/nx/nx.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/drivers/crypto/nx/nx.c
@@ -746,7 +746,7 @@ void nx_crypto_ctx_exit(struct crypto_tf
 {
 	struct nx_crypto_ctx *nx_ctx =3D crypto_tfm_ctx(tfm);
=20
-	kzfree(nx_ctx->kmem);
+	kfree_sensitive(nx_ctx->kmem);
 	nx_ctx->csbcpb =3D NULL;
 	nx_ctx->csbcpb_aead =3D NULL;
 	nx_ctx->in_sg =3D NULL;
@@ -762,7 +762,7 @@ void nx_crypto_ctx_aead_exit(struct cryp
 {
 	struct nx_crypto_ctx *nx_ctx =3D crypto_aead_ctx(tfm);
=20
-	kzfree(nx_ctx->kmem);
+	kfree_sensitive(nx_ctx->kmem);
 }
=20
 static int nx_probe(struct vio_dev *viodev, const struct vio_device_id *id)
--- a/drivers/crypto/virtio/virtio_crypto_algs.c~mm-treewide-rename-kzfree-=
to-kfree_sensitive
+++ a/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -167,7 +167,7 @@ static int virtio_crypto_alg_skcipher_in
 				num_in, vcrypto, GFP_ATOMIC);
 	if (err < 0) {
 		spin_unlock(&vcrypto->ctrl_lock);
-		kzfree(cipher_key);
+		kfree_sensitive(cipher_key);
 		return err;
 	}
 	virtqueue_kick(vcrypto->ctrl_vq);
@@ -184,7 +184,7 @@ static int virtio_crypto_alg_skcipher_in
 		spin_unlock(&vcrypto->ctrl_lock);
 		pr_err("virtio_crypto: Create session failed status: %u\n",
 			le32_to_cpu(vcrypto->input.status));
-		kzfree(cipher_key);
+		kfree_sensitive(cipher_key);
 		return -EINVAL;
 	}
=20
@@ -197,7 +197,7 @@ static int virtio_crypto_alg_skcipher_in
=20
 	spin_unlock(&vcrypto->ctrl_lock);
=20
-	kzfree(cipher_key);
+	kfree_sensitive(cipher_key);
 	return 0;
 }
=20
@@ -472,9 +472,9 @@ __virtio_crypto_skcipher_do_req(struct v
 	return 0;
=20
 free_iv:
-	kzfree(iv);
+	kfree_sensitive(iv);
 free:
-	kzfree(req_data);
+	kfree_sensitive(req_data);
 	kfree(sgs);
 	return err;
 }
@@ -583,7 +583,7 @@ static void virtio_crypto_skcipher_final
 		scatterwalk_map_and_copy(req->iv, req->dst,
 					 req->cryptlen - AES_BLOCK_SIZE,
 					 AES_BLOCK_SIZE, 0);
-	kzfree(vc_sym_req->iv);
+	kfree_sensitive(vc_sym_req->iv);
 	virtcrypto_clear_request(&vc_sym_req->base);
=20
 	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
--- a/drivers/crypto/virtio/virtio_crypto_core.c~mm-treewide-rename-kzfree-=
to-kfree_sensitive
+++ a/drivers/crypto/virtio/virtio_crypto_core.c
@@ -17,7 +17,7 @@ void
 virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
 {
 	if (vc_req) {
-		kzfree(vc_req->req_data);
+		kfree_sensitive(vc_req->req_data);
 		kfree(vc_req->sgs);
 	}
 }
--- a/drivers/md/dm-crypt.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/drivers/md/dm-crypt.c
@@ -407,7 +407,7 @@ static void crypt_iv_lmk_dtr(struct cryp
 		crypto_free_shash(lmk->hash_tfm);
 	lmk->hash_tfm =3D NULL;
=20
-	kzfree(lmk->seed);
+	kfree_sensitive(lmk->seed);
 	lmk->seed =3D NULL;
 }
=20
@@ -558,9 +558,9 @@ static void crypt_iv_tcw_dtr(struct cryp
 {
 	struct iv_tcw_private *tcw =3D &cc->iv_gen_private.tcw;
=20
-	kzfree(tcw->iv_seed);
+	kfree_sensitive(tcw->iv_seed);
 	tcw->iv_seed =3D NULL;
-	kzfree(tcw->whitening);
+	kfree_sensitive(tcw->whitening);
 	tcw->whitening =3D NULL;
=20
 	if (tcw->crc32_tfm && !IS_ERR(tcw->crc32_tfm))
@@ -994,8 +994,8 @@ static int crypt_iv_elephant(struct cryp
=20
 	kunmap_atomic(data);
 out:
-	kzfree(ks);
-	kzfree(es);
+	kfree_sensitive(ks);
+	kfree_sensitive(es);
 	skcipher_request_free(req);
 	return r;
 }
@@ -2294,7 +2294,7 @@ static int crypt_set_keyring_key(struct
=20
 	key =3D request_key(type, key_desc + 1, NULL);
 	if (IS_ERR(key)) {
-		kzfree(new_key_string);
+		kfree_sensitive(new_key_string);
 		return PTR_ERR(key);
 	}
=20
@@ -2304,7 +2304,7 @@ static int crypt_set_keyring_key(struct
 	if (ret < 0) {
 		up_read(&key->sem);
 		key_put(key);
-		kzfree(new_key_string);
+		kfree_sensitive(new_key_string);
 		return ret;
 	}
=20
@@ -2318,10 +2318,10 @@ static int crypt_set_keyring_key(struct
=20
 	if (!ret) {
 		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
-		kzfree(cc->key_string);
+		kfree_sensitive(cc->key_string);
 		cc->key_string =3D new_key_string;
 	} else
-		kzfree(new_key_string);
+		kfree_sensitive(new_key_string);
=20
 	return ret;
 }
@@ -2382,7 +2382,7 @@ static int crypt_set_key(struct crypt_co
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
=20
 	/* wipe references to any kernel keyring key */
-	kzfree(cc->key_string);
+	kfree_sensitive(cc->key_string);
 	cc->key_string =3D NULL;
=20
 	/* Decode key from its hex representation. */
@@ -2414,7 +2414,7 @@ static int crypt_wipe_key(struct crypt_c
 			return r;
 	}
=20
-	kzfree(cc->key_string);
+	kfree_sensitive(cc->key_string);
 	cc->key_string =3D NULL;
 	r =3D crypt_setkey(cc);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
@@ -2493,15 +2493,15 @@ static void crypt_dtr(struct dm_target *
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
=20
-	kzfree(cc->cipher_string);
-	kzfree(cc->key_string);
-	kzfree(cc->cipher_auth);
-	kzfree(cc->authenc_key);
+	kfree_sensitive(cc->cipher_string);
+	kfree_sensitive(cc->key_string);
+	kfree_sensitive(cc->cipher_auth);
+	kfree_sensitive(cc->authenc_key);
=20
 	mutex_destroy(&cc->bio_alloc_lock);
=20
 	/* Must zero key material before freeing */
-	kzfree(cc);
+	kfree_sensitive(cc);
=20
 	spin_lock(&dm_crypt_clients_lock);
 	WARN_ON(!dm_crypt_clients_n);
--- a/drivers/md/dm-integrity.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/drivers/md/dm-integrity.c
@@ -3405,8 +3405,8 @@ static struct scatterlist **dm_integrity
=20
 static void free_alg(struct alg_spec *a)
 {
-	kzfree(a->alg_string);
-	kzfree(a->key);
+	kfree_sensitive(a->alg_string);
+	kfree_sensitive(a->key);
 	memset(a, 0, sizeof *a);
 }
=20
@@ -4337,7 +4337,7 @@ static void dm_integrity_dtr(struct dm_t
 		for (i =3D 0; i < ic->journal_sections; i++) {
 			struct skcipher_request *req =3D ic->sk_requests[i];
 			if (req) {
-				kzfree(req->iv);
+				kfree_sensitive(req->iv);
 				skcipher_request_free(req);
 			}
 		}
--- a/drivers/misc/ibmvmc.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/drivers/misc/ibmvmc.c
@@ -286,7 +286,7 @@ static void *alloc_dma_buffer(struct vio
=20
 	if (dma_mapping_error(&vdev->dev, *dma_handle)) {
 		*dma_handle =3D 0;
-		kzfree(buffer);
+		kfree_sensitive(buffer);
 		return NULL;
 	}
=20
@@ -310,7 +310,7 @@ static void free_dma_buffer(struct vio_d
 	dma_unmap_single(&vdev->dev, dma_handle, size, DMA_BIDIRECTIONAL);
=20
 	/* deallocate memory */
-	kzfree(vaddr);
+	kfree_sensitive(vaddr);
 }
=20
 /**
@@ -883,7 +883,7 @@ static int ibmvmc_close(struct inode *in
 		spin_unlock_irqrestore(&hmc->lock, flags);
 	}
=20
-	kzfree(session);
+	kfree_sensitive(session);
=20
 	return rc;
 }
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c~mm-treewide-re=
name-kzfree-to-kfree_sensitive
+++ a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -137,7 +137,7 @@ static void hclge_free_vector_ring_chain
=20
 	while (chain) {
 		chain_tmp =3D chain->next;
-		kzfree(chain);
+		kfree_sensitive(chain);
 		chain =3D chain_tmp;
 	}
 }
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c~mm-treewide-rename-kzf=
ree-to-kfree_sensitive
+++ a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -960,9 +960,9 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_a
 	return 0;
=20
 err_aead:
-	kzfree(xs->aead);
+	kfree_sensitive(xs->aead);
 err_xs:
-	kzfree(xs);
+	kfree_sensitive(xs);
 err_out:
 	msgbuf[1] =3D err;
 	return err;
@@ -1047,7 +1047,7 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_a
 	ixgbe_ipsec_del_sa(xs);
=20
 	/* remove the xs that was made-up in the add request */
-	kzfree(xs);
+	kfree_sensitive(xs);
=20
 	return 0;
 }
--- a/drivers/net/ppp/ppp_mppe.c~mm-treewide-rename-kzfree-to-kfree_sensiti=
ve
+++ a/drivers/net/ppp/ppp_mppe.c
@@ -222,7 +222,7 @@ out_free:
 	kfree(state->sha1_digest);
 	if (state->sha1) {
 		crypto_free_shash(state->sha1->tfm);
-		kzfree(state->sha1);
+		kfree_sensitive(state->sha1);
 	}
 	kfree(state);
 out:
@@ -238,8 +238,8 @@ static void mppe_free(void *arg)
 	if (state) {
 		kfree(state->sha1_digest);
 		crypto_free_shash(state->sha1->tfm);
-		kzfree(state->sha1);
-		kzfree(state);
+		kfree_sensitive(state->sha1);
+		kfree_sensitive(state);
 	}
 }
=20
--- a/drivers/net/wireguard/noise.c~mm-treewide-rename-kzfree-to-kfree_sens=
itive
+++ a/drivers/net/wireguard/noise.c
@@ -114,7 +114,7 @@ static struct noise_keypair *keypair_cre
=20
 static void keypair_free_rcu(struct rcu_head *rcu)
 {
-	kzfree(container_of(rcu, struct noise_keypair, rcu));
+	kfree_sensitive(container_of(rcu, struct noise_keypair, rcu));
 }
=20
 static void keypair_free_kref(struct kref *kref)
@@ -821,7 +821,7 @@ bool wg_noise_handshake_begin_session(st
 			handshake->entry.peer->device->index_hashtable,
 			&handshake->entry, &new_keypair->entry);
 	} else {
-		kzfree(new_keypair);
+		kfree_sensitive(new_keypair);
 	}
 	rcu_read_unlock_bh();
=20
--- a/drivers/net/wireguard/peer.c~mm-treewide-rename-kzfree-to-kfree_sensi=
tive
+++ a/drivers/net/wireguard/peer.c
@@ -203,7 +203,7 @@ static void rcu_release(struct rcu_head
 	/* The final zeroing takes care of clearing any remaining handshake key
 	 * material and other potentially sensitive information.
 	 */
-	kzfree(peer);
+	kfree_sensitive(peer);
 }
=20
 static void kref_release(struct kref *refcount)
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c~mm-treewide-rename-kzfre=
e-to-kfree_sensitive
+++ a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1369,7 +1369,7 @@ static void iwl_pcie_rx_handle_rb(struct
 					   &rxcb, rxq->id);
=20
 		if (reclaim) {
-			kzfree(txq->entries[cmd_index].free_buf);
+			kfree_sensitive(txq->entries[cmd_index].free_buf);
 			txq->entries[cmd_index].free_buf =3D NULL;
 		}
=20
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c~mm-treewide-rename-kzfre=
e-to-kfree_sensitive
+++ a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -721,8 +721,8 @@ static void iwl_pcie_txq_free(struct iwl
 	/* De-alloc array of command/tx buffers */
 	if (txq_id =3D=3D trans->txqs.cmd.q_id)
 		for (i =3D 0; i < txq->n_window; i++) {
-			kzfree(txq->entries[i].cmd);
-			kzfree(txq->entries[i].free_buf);
+			kfree_sensitive(txq->entries[i].cmd);
+			kfree_sensitive(txq->entries[i].free_buf);
 		}
=20
 	/* De-alloc circular buffer of TFDs */
@@ -1765,7 +1765,7 @@ static int iwl_pcie_enqueue_hcmd(struct
 	BUILD_BUG_ON(IWL_TFH_NUM_TBS > sizeof(out_meta->tbs) * BITS_PER_BYTE);
 	out_meta->flags =3D cmd->flags;
 	if (WARN_ON_ONCE(txq->entries[idx].free_buf))
-		kzfree(txq->entries[idx].free_buf);
+		kfree_sensitive(txq->entries[idx].free_buf);
 	txq->entries[idx].free_buf =3D dup_buf;
=20
 	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr_wide);
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c~mm-treewide-rename-=
kzfree-to-kfree_sensitive
+++ a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1026,7 +1026,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(st
 	BUILD_BUG_ON(IWL_TFH_NUM_TBS > sizeof(out_meta->tbs) * BITS_PER_BYTE);
 	out_meta->flags =3D cmd->flags;
 	if (WARN_ON_ONCE(txq->entries[idx].free_buf))
-		kzfree(txq->entries[idx].free_buf);
+		kfree_sensitive(txq->entries[idx].free_buf);
 	txq->entries[idx].free_buf =3D dup_buf;
=20
 	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr_wide);
@@ -1257,8 +1257,8 @@ static void iwl_pcie_gen2_txq_free(struc
 	/* De-alloc array of command/tx buffers */
 	if (txq_id =3D=3D trans->txqs.cmd.q_id)
 		for (i =3D 0; i < txq->n_window; i++) {
-			kzfree(txq->entries[i].cmd);
-			kzfree(txq->entries[i].free_buf);
+			kfree_sensitive(txq->entries[i].cmd);
+			kfree_sensitive(txq->entries[i].free_buf);
 		}
 	del_timer_sync(&txq->stuck_timer);
=20
--- a/drivers/net/wireless/intersil/orinoco/wext.c~mm-treewide-rename-kzfre=
e-to-kfree_sensitive
+++ a/drivers/net/wireless/intersil/orinoco/wext.c
@@ -31,8 +31,8 @@ static int orinoco_set_key(struct orinoc
 			   enum orinoco_alg alg, const u8 *key, int key_len,
 			   const u8 *seq, int seq_len)
 {
-	kzfree(priv->keys[index].key);
-	kzfree(priv->keys[index].seq);
+	kfree_sensitive(priv->keys[index].key);
+	kfree_sensitive(priv->keys[index].seq);
=20
 	if (key_len) {
 		priv->keys[index].key =3D kzalloc(key_len, GFP_ATOMIC);
--- a/drivers/s390/crypto/ap_bus.h~mm-treewide-rename-kzfree-to-kfree_sensi=
tive
+++ a/drivers/s390/crypto/ap_bus.h
@@ -218,8 +218,8 @@ static inline void ap_init_message(struc
  */
 static inline void ap_release_message(struct ap_message *ap_msg)
 {
-	kzfree(ap_msg->message);
-	kzfree(ap_msg->private);
+	kfree_sensitive(ap_msg->message);
+	kfree_sensitive(ap_msg->private);
 }
=20
 /*
--- a/drivers/staging/ks7010/ks_hostif.c~mm-treewide-rename-kzfree-to-kfree=
_sensitive
+++ a/drivers/staging/ks7010/ks_hostif.c
@@ -246,7 +246,7 @@ michael_mic(u8 *key, u8 *data, unsigned
 	ret =3D crypto_shash_finup(desc, data + 12, len - 12, result);
=20
 err_free_desc:
-	kzfree(desc);
+	kfree_sensitive(desc);
=20
 err_free_tfm:
 	crypto_free_shash(tfm);
--- a/drivers/staging/rtl8723bs/core/rtw_security.c~mm-treewide-rename-kzfr=
ee-to-kfree_sensitive
+++ a/drivers/staging/rtl8723bs/core/rtw_security.c
@@ -2251,7 +2251,7 @@ static void gf_mulx(u8 *pad)
=20
 static void aes_encrypt_deinit(void *ctx)
 {
-	kzfree(ctx);
+	kfree_sensitive(ctx);
 }
=20
=20
--- a/drivers/staging/wlan-ng/p80211netdev.c~mm-treewide-rename-kzfree-to-k=
free_sensitive
+++ a/drivers/staging/wlan-ng/p80211netdev.c
@@ -429,7 +429,7 @@ static netdev_tx_t p80211knetdev_hard_st
 failed:
 	/* Free up the WEP buffer if it's not the same as the skb */
 	if ((p80211_wep.data) && (p80211_wep.data !=3D skb->data))
-		kzfree(p80211_wep.data);
+		kfree_sensitive(p80211_wep.data);
=20
 	/* we always free the skb here, never in a lower level. */
 	if (!result)
--- a/drivers/target/iscsi/iscsi_target_auth.c~mm-treewide-rename-kzfree-to=
-kfree_sensitive
+++ a/drivers/target/iscsi/iscsi_target_auth.c
@@ -484,7 +484,7 @@ static int chap_server_compute_hash(
 	pr_debug("[server] Sending CHAP_R=3D0x%s\n", response);
 	auth_ret =3D 0;
 out:
-	kzfree(desc);
+	kfree_sensitive(desc);
 	if (tfm)
 		crypto_free_shash(tfm);
 	kfree(initiatorchg);
--- a/fs/cifs/cifsencrypt.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/fs/cifs/cifsencrypt.c
@@ -797,7 +797,7 @@ calc_seckey(struct cifs_ses *ses)
 	ses->auth_key.len =3D CIFS_SESS_KEY_SIZE;
=20
 	memzero_explicit(sec_key, CIFS_SESS_KEY_SIZE);
-	kzfree(ctx_arc4);
+	kfree_sensitive(ctx_arc4);
 	return 0;
 }
=20
--- a/fs/cifs/connect.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/fs/cifs/connect.c
@@ -2182,7 +2182,7 @@ cifs_parse_mount_options(const char *mou
 			tmp_end++;
 			if (!(tmp_end < end && tmp_end[1] =3D=3D delim)) {
 				/* No it is not. Set the password to NULL */
-				kzfree(vol->password);
+				kfree_sensitive(vol->password);
 				vol->password =3D NULL;
 				break;
 			}
@@ -2220,7 +2220,7 @@ cifs_parse_mount_options(const char *mou
 					options =3D end;
 			}
=20
-			kzfree(vol->password);
+			kfree_sensitive(vol->password);
 			/* Now build new password string */
 			temp_len =3D strlen(value);
 			vol->password =3D kzalloc(temp_len+1, GFP_KERNEL);
@@ -3198,7 +3198,7 @@ cifs_set_cifscreds(struct smb_vol *vol,
 			rc =3D -ENOMEM;
 			kfree(vol->username);
 			vol->username =3D NULL;
-			kzfree(vol->password);
+			kfree_sensitive(vol->password);
 			vol->password =3D NULL;
 			goto out_key_put;
 		}
@@ -4219,7 +4219,7 @@ void
 cifs_cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
 	kfree(volume_info->username);
-	kzfree(volume_info->password);
+	kfree_sensitive(volume_info->password);
 	kfree(volume_info->UNC);
 	kfree(volume_info->domainname);
 	kfree(volume_info->iocharset);
@@ -5343,7 +5343,7 @@ cifs_construct_tcon(struct cifs_sb_info
=20
 out:
 	kfree(vol_info->username);
-	kzfree(vol_info->password);
+	kfree_sensitive(vol_info->password);
 	kfree(vol_info);
=20
 	return tcon;
--- a/fs/cifs/dfs_cache.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/fs/cifs/dfs_cache.c
@@ -1131,7 +1131,7 @@ err_free_domainname:
 err_free_unc:
 	kfree(new->UNC);
 err_free_password:
-	kzfree(new->password);
+	kfree_sensitive(new->password);
 err_free_username:
 	kfree(new->username);
 	kfree(new);
--- a/fs/cifs/misc.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/fs/cifs/misc.c
@@ -103,12 +103,12 @@ sesInfoFree(struct cifs_ses *buf_to_free
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
 	kfree(buf_to_free->serverNOS);
-	kzfree(buf_to_free->password);
+	kfree_sensitive(buf_to_free->password);
 	kfree(buf_to_free->user_name);
 	kfree(buf_to_free->domainName);
-	kzfree(buf_to_free->auth_key.response);
+	kfree_sensitive(buf_to_free->auth_key.response);
 	kfree(buf_to_free->iface_list);
-	kzfree(buf_to_free);
+	kfree_sensitive(buf_to_free);
 }
=20
 struct cifs_tcon *
@@ -148,7 +148,7 @@ tconInfoFree(struct cifs_tcon *buf_to_fr
 	}
 	atomic_dec(&tconInfoAllocCount);
 	kfree(buf_to_free->nativeFileSystem);
-	kzfree(buf_to_free->password);
+	kfree_sensitive(buf_to_free->password);
 	kfree(buf_to_free->crfid.fid);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	kfree(buf_to_free->dfs_path);
--- a/fs/crypto/keyring.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/fs/crypto/keyring.c
@@ -51,7 +51,7 @@ static void free_master_key(struct fscry
 	}
=20
 	key_put(mk->mk_users);
-	kzfree(mk);
+	kfree_sensitive(mk);
 }
=20
 static inline bool valid_key_spec(const struct fscrypt_key_specifier *spec)
@@ -522,7 +522,7 @@ static int fscrypt_provisioning_key_prep
 static void fscrypt_provisioning_key_free_preparse(
 					struct key_preparsed_payload *prep)
 {
-	kzfree(prep->payload.data[0]);
+	kfree_sensitive(prep->payload.data[0]);
 }
=20
 static void fscrypt_provisioning_key_describe(const struct key *key,
@@ -539,7 +539,7 @@ static void fscrypt_provisioning_key_des
=20
 static void fscrypt_provisioning_key_destroy(struct key *key)
 {
-	kzfree(key->payload.data[0]);
+	kfree_sensitive(key->payload.data[0]);
 }
=20
 static struct key_type key_type_fscrypt_provisioning =3D {
--- a/fs/crypto/keysetup_v1.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/fs/crypto/keysetup_v1.c
@@ -155,7 +155,7 @@ static void free_direct_key(struct fscry
 {
 	if (dk) {
 		crypto_free_skcipher(dk->dk_ctfm);
-		kzfree(dk);
+		kfree_sensitive(dk);
 	}
 }
=20
@@ -285,7 +285,7 @@ static int setup_v1_file_key_derived(str
=20
 	err =3D fscrypt_set_per_file_enc_key(ci, derived_key);
 out:
-	kzfree(derived_key);
+	kfree_sensitive(derived_key);
 	return err;
 }
=20
--- a/fs/ecryptfs/keystore.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/fs/ecryptfs/keystore.c
@@ -838,7 +838,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 out_release_free_unlock:
 	crypto_free_shash(s->hash_tfm);
 out_free_unlock:
-	kzfree(s->block_aligned_filename);
+	kfree_sensitive(s->block_aligned_filename);
 out_unlock:
 	mutex_unlock(s->tfm_mutex);
 out:
@@ -847,7 +847,7 @@ out:
 		key_put(auth_tok_key);
 	}
 	skcipher_request_free(s->skcipher_req);
-	kzfree(s->hash_desc);
+	kfree_sensitive(s->hash_desc);
 	kfree(s);
 	return rc;
 }
--- a/fs/ecryptfs/messaging.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/fs/ecryptfs/messaging.c
@@ -175,7 +175,7 @@ int ecryptfs_exorcise_daemon(struct ecry
 	}
 	hlist_del(&daemon->euid_chain);
 	mutex_unlock(&daemon->mux);
-	kzfree(daemon);
+	kfree_sensitive(daemon);
 out:
 	return rc;
 }
--- a/include/crypto/aead.h~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/include/crypto/aead.h
@@ -425,7 +425,7 @@ static inline struct aead_request *aead_
  */
 static inline void aead_request_free(struct aead_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
=20
 /**
--- a/include/crypto/akcipher.h~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/include/crypto/akcipher.h
@@ -207,7 +207,7 @@ static inline struct akcipher_request *a
  */
 static inline void akcipher_request_free(struct akcipher_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
=20
 /**
--- a/include/crypto/gf128mul.h~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/include/crypto/gf128mul.h
@@ -230,7 +230,7 @@ void gf128mul_4k_bbe(be128 *a, const str
 void gf128mul_x8_ble(le128 *r, const le128 *x);
 static inline void gf128mul_free_4k(struct gf128mul_4k *t)
 {
-	kzfree(t);
+	kfree_sensitive(t);
 }
=20
=20
--- a/include/crypto/hash.h~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/include/crypto/hash.h
@@ -606,7 +606,7 @@ static inline struct ahash_request *ahas
  */
 static inline void ahash_request_free(struct ahash_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
=20
 static inline void ahash_request_zero(struct ahash_request *req)
--- a/include/crypto/internal/acompress.h~mm-treewide-rename-kzfree-to-kfre=
e_sensitive
+++ a/include/crypto/internal/acompress.h
@@ -46,7 +46,7 @@ static inline struct acomp_req *__acomp_
=20
 static inline void __acomp_request_free(struct acomp_req *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
=20
 /**
--- a/include/crypto/kpp.h~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/include/crypto/kpp.h
@@ -187,7 +187,7 @@ static inline struct kpp_request *kpp_re
  */
 static inline void kpp_request_free(struct kpp_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
=20
 /**
--- a/include/crypto/skcipher.h~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/include/crypto/skcipher.h
@@ -508,7 +508,7 @@ static inline struct skcipher_request *s
  */
 static inline void skcipher_request_free(struct skcipher_request *req)
 {
-	kzfree(req);
+	kfree_sensitive(req);
 }
=20
 static inline void skcipher_request_zero(struct skcipher_request *req)
--- a/include/linux/slab.h~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/include/linux/slab.h
@@ -186,10 +186,12 @@ void memcg_deactivate_kmem_caches(struct
  */
 void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
-void kzfree(const void *);
+void kfree_sensitive(const void *);
 size_t __ksize(const void *);
 size_t ksize(const void *);
=20
+#define kzfree(x)	kfree_sensitive(x)	/* For backward compatibility */
+
 #ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
 void __check_heap_object(const void *ptr, unsigned long n, struct page *pa=
ge,
 			bool to_user);
--- a/lib/mpi/mpiutil.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/lib/mpi/mpiutil.c
@@ -69,7 +69,7 @@ void mpi_free_limb_space(mpi_ptr_t a)
 	if (!a)
 		return;
=20
-	kzfree(a);
+	kfree_sensitive(a);
 }
=20
 void mpi_assign_limb_space(MPI a, mpi_ptr_t ap, unsigned nlimbs)
@@ -95,7 +95,7 @@ int mpi_resize(MPI a, unsigned nlimbs)
 		if (!p)
 			return -ENOMEM;
 		memcpy(p, a->d, a->alloced * sizeof(mpi_limb_t));
-		kzfree(a->d);
+		kfree_sensitive(a->d);
 		a->d =3D p;
 	} else {
 		a->d =3D kcalloc(nlimbs, sizeof(mpi_limb_t), GFP_KERNEL);
@@ -112,7 +112,7 @@ void mpi_free(MPI a)
 		return;
=20
 	if (a->flags & 4)
-		kzfree(a->d);
+		kfree_sensitive(a->d);
 	else
 		mpi_free_limb_space(a->d);
=20
--- a/lib/test_kasan.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/lib/test_kasan.c
@@ -766,15 +766,15 @@ static noinline void __init kmalloc_doub
 	char *ptr;
 	size_t size =3D 16;
=20
-	pr_info("double-free (kzfree)\n");
+	pr_info("double-free (kfree_sensitive)\n");
 	ptr =3D kmalloc(size, GFP_KERNEL);
 	if (!ptr) {
 		pr_err("Allocation failed\n");
 		return;
 	}
=20
-	kzfree(ptr);
-	kzfree(ptr);
+	kfree_sensitive(ptr);
+	kfree_sensitive(ptr);
 }
=20
 #ifdef CONFIG_KASAN_VMALLOC
--- a/mm/slab_common.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/mm/slab_common.c
@@ -1708,17 +1708,17 @@ void *krealloc(const void *p, size_t new
 EXPORT_SYMBOL(krealloc);
=20
 /**
- * kzfree - like kfree but zero memory
+ * kfree_sensitive - Clear sensitive information in memory before freeing
  * @p: object to free memory of
  *
  * The memory of the object @p points to is zeroed before freed.
- * If @p is %NULL, kzfree() does nothing.
+ * If @p is %NULL, kfree_sensitive() does nothing.
  *
  * Note: this function zeroes the whole allocated buffer which can be a go=
od
  * deal bigger than the requested buffer size passed to kmalloc(). So be
  * careful when using this function in performance sensitive code.
  */
-void kzfree(const void *p)
+void kfree_sensitive(const void *p)
 {
 	size_t ks;
 	void *mem =3D (void *)p;
@@ -1729,7 +1729,7 @@ void kzfree(const void *p)
 	memzero_explicit(mem, ks);
 	kfree(mem);
 }
-EXPORT_SYMBOL(kzfree);
+EXPORT_SYMBOL(kfree_sensitive);
=20
 /**
  * ksize - get the actual amount of memory allocated for a given object
--- a/net/atm/mpoa_caches.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/atm/mpoa_caches.c
@@ -180,7 +180,7 @@ static int cache_hit(in_cache_entry *ent
 static void in_cache_put(in_cache_entry *entry)
 {
 	if (refcount_dec_and_test(&entry->use)) {
-		kzfree(entry);
+		kfree_sensitive(entry);
 	}
 }
=20
@@ -415,7 +415,7 @@ static eg_cache_entry *eg_cache_get_by_s
 static void eg_cache_put(eg_cache_entry *entry)
 {
 	if (refcount_dec_and_test(&entry->use)) {
-		kzfree(entry);
+		kfree_sensitive(entry);
 	}
 }
=20
--- a/net/bluetooth/ecdh_helper.c~mm-treewide-rename-kzfree-to-kfree_sensit=
ive
+++ a/net/bluetooth/ecdh_helper.c
@@ -104,7 +104,7 @@ int compute_ecdh_secret(struct crypto_kp
 free_all:
 	kpp_request_free(req);
 free_tmp:
-	kzfree(tmp);
+	kfree_sensitive(tmp);
 	return err;
 }
=20
@@ -151,9 +151,9 @@ int set_ecdh_privkey(struct crypto_kpp *
 	err =3D crypto_kpp_set_secret(tfm, buf, buf_len);
 	/* fall through */
 free_all:
-	kzfree(buf);
+	kfree_sensitive(buf);
 free_tmp:
-	kzfree(tmp);
+	kfree_sensitive(tmp);
 	return err;
 }
=20
--- a/net/bluetooth/smp.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/bluetooth/smp.c
@@ -753,9 +753,9 @@ static void smp_chan_destroy(struct l2ca
 	complete =3D test_bit(SMP_FLAG_COMPLETE, &smp->flags);
 	mgmt_smp_complete(hcon, complete);
=20
-	kzfree(smp->csrk);
-	kzfree(smp->slave_csrk);
-	kzfree(smp->link_key);
+	kfree_sensitive(smp->csrk);
+	kfree_sensitive(smp->slave_csrk);
+	kfree_sensitive(smp->link_key);
=20
 	crypto_free_shash(smp->tfm_cmac);
 	crypto_free_kpp(smp->tfm_ecdh);
@@ -789,7 +789,7 @@ static void smp_chan_destroy(struct l2ca
 	}
=20
 	chan->data =3D NULL;
-	kzfree(smp);
+	kfree_sensitive(smp);
 	hci_conn_drop(hcon);
 }
=20
@@ -1156,7 +1156,7 @@ static void sc_generate_link_key(struct
 		const u8 salt[16] =3D { 0x31, 0x70, 0x6d, 0x74 };
=20
 		if (smp_h7(smp->tfm_cmac, smp->tk, salt, smp->link_key)) {
-			kzfree(smp->link_key);
+			kfree_sensitive(smp->link_key);
 			smp->link_key =3D NULL;
 			return;
 		}
@@ -1165,14 +1165,14 @@ static void sc_generate_link_key(struct
 		const u8 tmp1[4] =3D { 0x31, 0x70, 0x6d, 0x74 };
=20
 		if (smp_h6(smp->tfm_cmac, smp->tk, tmp1, smp->link_key)) {
-			kzfree(smp->link_key);
+			kfree_sensitive(smp->link_key);
 			smp->link_key =3D NULL;
 			return;
 		}
 	}
=20
 	if (smp_h6(smp->tfm_cmac, smp->link_key, lebr, smp->link_key)) {
-		kzfree(smp->link_key);
+		kfree_sensitive(smp->link_key);
 		smp->link_key =3D NULL;
 		return;
 	}
@@ -1407,7 +1407,7 @@ static struct smp_chan *smp_chan_create(
 free_shash:
 	crypto_free_shash(smp->tfm_cmac);
 zfree_smp:
-	kzfree(smp);
+	kfree_sensitive(smp);
 	return NULL;
 }
=20
@@ -3278,7 +3278,7 @@ static struct l2cap_chan *smp_add_cid(st
 	tfm_cmac =3D crypto_alloc_shash("cmac(aes)", 0, 0);
 	if (IS_ERR(tfm_cmac)) {
 		BT_ERR("Unable to create CMAC crypto context");
-		kzfree(smp);
+		kfree_sensitive(smp);
 		return ERR_CAST(tfm_cmac);
 	}
=20
@@ -3286,7 +3286,7 @@ static struct l2cap_chan *smp_add_cid(st
 	if (IS_ERR(tfm_ecdh)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		crypto_free_shash(tfm_cmac);
-		kzfree(smp);
+		kfree_sensitive(smp);
 		return ERR_CAST(tfm_ecdh);
 	}
=20
@@ -3300,7 +3300,7 @@ create_chan:
 		if (smp) {
 			crypto_free_shash(smp->tfm_cmac);
 			crypto_free_kpp(smp->tfm_ecdh);
-			kzfree(smp);
+			kfree_sensitive(smp);
 		}
 		return ERR_PTR(-ENOMEM);
 	}
@@ -3347,7 +3347,7 @@ static void smp_del_chan(struct l2cap_ch
 		chan->data =3D NULL;
 		crypto_free_shash(smp->tfm_cmac);
 		crypto_free_kpp(smp->tfm_ecdh);
-		kzfree(smp);
+		kfree_sensitive(smp);
 	}
=20
 	l2cap_chan_put(chan);
--- a/net/core/sock.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/core/sock.c
@@ -2271,7 +2271,7 @@ static inline void __sock_kfree_s(struct
 	if (WARN_ON_ONCE(!mem))
 		return;
 	if (nullify)
-		kzfree(mem);
+		kfree_sensitive(mem);
 	else
 		kfree(mem);
 	atomic_sub(size, &sk->sk_omem_alloc);
--- a/net/ipv4/tcp_fastopen.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/ipv4/tcp_fastopen.c
@@ -38,7 +38,7 @@ static void tcp_fastopen_ctx_free(struct
 	struct tcp_fastopen_context *ctx =3D
 	    container_of(head, struct tcp_fastopen_context, rcu);
=20
-	kzfree(ctx);
+	kfree_sensitive(ctx);
 }
=20
 void tcp_fastopen_destroy_cipher(struct sock *sk)
--- a/net/mac80211/aead_api.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/mac80211/aead_api.c
@@ -41,7 +41,7 @@ int aead_encrypt(struct crypto_aead *tfm
 	aead_request_set_ad(aead_req, sg[0].length);
=20
 	crypto_aead_encrypt(aead_req);
-	kzfree(aead_req);
+	kfree_sensitive(aead_req);
=20
 	return 0;
 }
@@ -76,7 +76,7 @@ int aead_decrypt(struct crypto_aead *tfm
 	aead_request_set_ad(aead_req, sg[0].length);
=20
 	err =3D crypto_aead_decrypt(aead_req);
-	kzfree(aead_req);
+	kfree_sensitive(aead_req);
=20
 	return err;
 }
--- a/net/mac80211/aes_gmac.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/mac80211/aes_gmac.c
@@ -60,7 +60,7 @@ int ieee80211_aes_gmac(struct crypto_aea
 	aead_request_set_ad(aead_req, GMAC_AAD_LEN + data_len);
=20
 	crypto_aead_encrypt(aead_req);
-	kzfree(aead_req);
+	kfree_sensitive(aead_req);
=20
 	return 0;
 }
--- a/net/mac80211/key.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/mac80211/key.c
@@ -732,7 +732,7 @@ static void ieee80211_key_free_common(st
 		ieee80211_aes_gcm_key_free(key->u.gcmp.tfm);
 		break;
 	}
-	kzfree(key);
+	kfree_sensitive(key);
 }
=20
 static void __ieee80211_key_destroy(struct ieee80211_key *key,
--- a/net/mac802154/llsec.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/mac802154/llsec.c
@@ -49,7 +49,7 @@ void mac802154_llsec_destroy(struct mac8
=20
 		msl =3D container_of(sl, struct mac802154_llsec_seclevel, level);
 		list_del(&sl->list);
-		kzfree(msl);
+		kfree_sensitive(msl);
 	}
=20
 	list_for_each_entry_safe(dev, dn, &sec->table.devices, list) {
@@ -66,7 +66,7 @@ void mac802154_llsec_destroy(struct mac8
 		mkey =3D container_of(key->key, struct mac802154_llsec_key, key);
 		list_del(&key->list);
 		llsec_key_put(mkey);
-		kzfree(key);
+		kfree_sensitive(key);
 	}
 }
=20
@@ -155,7 +155,7 @@ err_tfm:
 		if (key->tfm[i])
 			crypto_free_aead(key->tfm[i]);
=20
-	kzfree(key);
+	kfree_sensitive(key);
 	return NULL;
 }
=20
@@ -170,7 +170,7 @@ static void llsec_key_release(struct kre
 		crypto_free_aead(key->tfm[i]);
=20
 	crypto_free_sync_skcipher(key->tfm0);
-	kzfree(key);
+	kfree_sensitive(key);
 }
=20
 static struct mac802154_llsec_key*
@@ -261,7 +261,7 @@ int mac802154_llsec_key_add(struct mac80
 	return 0;
=20
 fail:
-	kzfree(new);
+	kfree_sensitive(new);
 	return -ENOMEM;
 }
=20
@@ -341,10 +341,10 @@ static void llsec_dev_free(struct mac802
 				      devkey);
=20
 		list_del(&pos->list);
-		kzfree(devkey);
+		kfree_sensitive(devkey);
 	}
=20
-	kzfree(dev);
+	kfree_sensitive(dev);
 }
=20
 int mac802154_llsec_dev_add(struct mac802154_llsec *sec,
@@ -682,7 +682,7 @@ llsec_do_encrypt_auth(struct sk_buff *sk
=20
 	rc =3D crypto_aead_encrypt(req);
=20
-	kzfree(req);
+	kfree_sensitive(req);
=20
 	return rc;
 }
@@ -886,7 +886,7 @@ llsec_do_decrypt_auth(struct sk_buff *sk
=20
 	rc =3D crypto_aead_decrypt(req);
=20
-	kzfree(req);
+	kfree_sensitive(req);
 	skb_trim(skb, skb->len - authlen);
=20
 	return rc;
@@ -926,7 +926,7 @@ llsec_update_devkey_record(struct mac802
 		if (!devkey)
 			list_add_rcu(&next->devkey.list, &dev->dev.keys);
 		else
-			kzfree(next);
+			kfree_sensitive(next);
=20
 		spin_unlock_bh(&dev->lock);
 	}
--- a/net/sctp/auth.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/sctp/auth.c
@@ -49,7 +49,7 @@ void sctp_auth_key_put(struct sctp_auth_
 		return;
=20
 	if (refcount_dec_and_test(&key->refcnt)) {
-		kzfree(key);
+		kfree_sensitive(key);
 		SCTP_DBG_OBJCNT_DEC(keys);
 	}
 }
--- a/net/sctp/socket.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/sctp/socket.c
@@ -3755,7 +3755,7 @@ static int sctp_setsockopt_auth_key(stru
 	}
=20
 out:
-	kzfree(authkey);
+	kfree_sensitive(authkey);
 	return ret;
 }
=20
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c~mm-treewide-rename-kzfree-to-kf=
ree_sensitive
+++ a/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -1003,7 +1003,7 @@ krb5_rc4_setup_seq_key(struct krb5_ctx *
 	err =3D 0;
=20
 out_err:
-	kzfree(desc);
+	kfree_sensitive(desc);
 	crypto_free_shash(hmac);
 	dprintk("%s: returning %d\n", __func__, err);
 	return err;
@@ -1079,7 +1079,7 @@ krb5_rc4_setup_enc_key(struct krb5_ctx *
 	err =3D 0;
=20
 out_err:
-	kzfree(desc);
+	kfree_sensitive(desc);
 	crypto_free_shash(hmac);
 	dprintk("%s: returning %d\n", __func__, err);
 	return err;
--- a/net/sunrpc/auth_gss/gss_krb5_keys.c~mm-treewide-rename-kzfree-to-kfre=
e_sensitive
+++ a/net/sunrpc/auth_gss/gss_krb5_keys.c
@@ -228,11 +228,11 @@ u32 krb5_derive_key(const struct gss_krb
 	ret =3D 0;
=20
 err_free_raw:
-	kzfree(rawkey);
+	kfree_sensitive(rawkey);
 err_free_out:
-	kzfree(outblockdata);
+	kfree_sensitive(outblockdata);
 err_free_in:
-	kzfree(inblockdata);
+	kfree_sensitive(inblockdata);
 err_free_cipher:
 	crypto_free_sync_skcipher(cipher);
 err_return:
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c~mm-treewide-rename-kzfree-to-kfre=
e_sensitive
+++ a/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -443,7 +443,7 @@ context_derive_keys_rc4(struct krb5_ctx
 	desc->tfm =3D hmac;
=20
 	err =3D crypto_shash_digest(desc, sigkeyconstant, slen, ctx->cksum);
-	kzfree(desc);
+	kfree_sensitive(desc);
 	if (err)
 		goto out_err_free_hmac;
 	/*
--- a/net/tipc/crypto.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/tipc/crypto.c
@@ -441,7 +441,7 @@ static int tipc_aead_init(struct tipc_ae
 	/* Allocate per-cpu TFM entry pointer */
 	tmp->tfm_entry =3D alloc_percpu(struct tipc_tfm *);
 	if (!tmp->tfm_entry) {
-		kzfree(tmp);
+		kfree_sensitive(tmp);
 		return -ENOMEM;
 	}
=20
@@ -491,7 +491,7 @@ static int tipc_aead_init(struct tipc_ae
 	/* Not any TFM is allocated? */
 	if (!tfm_cnt) {
 		free_percpu(tmp->tfm_entry);
-		kzfree(tmp);
+		kfree_sensitive(tmp);
 		return err;
 	}
=20
@@ -545,7 +545,7 @@ static int tipc_aead_clone(struct tipc_a
=20
 	aead->tfm_entry =3D alloc_percpu_gfp(struct tipc_tfm *, GFP_ATOMIC);
 	if (unlikely(!aead->tfm_entry)) {
-		kzfree(aead);
+		kfree_sensitive(aead);
 		return -ENOMEM;
 	}
=20
@@ -1352,7 +1352,7 @@ int tipc_crypto_start(struct tipc_crypto
 	/* Allocate statistic structure */
 	c->stats =3D alloc_percpu_gfp(struct tipc_crypto_stats, GFP_ATOMIC);
 	if (!c->stats) {
-		kzfree(c);
+		kfree_sensitive(c);
 		return -ENOMEM;
 	}
=20
@@ -1408,7 +1408,7 @@ void tipc_crypto_stop(struct tipc_crypto
 	free_percpu(c->stats);
=20
 	*crypto =3D NULL;
-	kzfree(c);
+	kfree_sensitive(c);
 }
=20
 void tipc_crypto_timeout(struct tipc_crypto *rx)
--- a/net/wireless/core.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/wireless/core.c
@@ -1124,7 +1124,7 @@ static void __cfg80211_unregister_wdev(s
 	}
=20
 #ifdef CONFIG_CFG80211_WEXT
-	kzfree(wdev->wext.keys);
+	kfree_sensitive(wdev->wext.keys);
 	wdev->wext.keys =3D NULL;
 #endif
 	/* only initialized if we have a netdev */
--- a/net/wireless/ibss.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/wireless/ibss.c
@@ -127,7 +127,7 @@ int __cfg80211_join_ibss(struct cfg80211
 		return -EINVAL;
=20
 	if (WARN_ON(wdev->connect_keys))
-		kzfree(wdev->connect_keys);
+		kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys =3D connkeys;
=20
 	wdev->ibss_fixed =3D params->channel_fixed;
@@ -161,7 +161,7 @@ static void __cfg80211_clear_ibss(struct
=20
 	ASSERT_WDEV_LOCK(wdev);
=20
-	kzfree(wdev->connect_keys);
+	kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys =3D NULL;
=20
 	rdev_set_qos_map(rdev, dev, NULL);
--- a/net/wireless/lib80211_crypt_tkip.c~mm-treewide-rename-kzfree-to-kfree=
_sensitive
+++ a/net/wireless/lib80211_crypt_tkip.c
@@ -131,7 +131,7 @@ static void lib80211_tkip_deinit(void *p
 		crypto_free_shash(_priv->tx_tfm_michael);
 		crypto_free_shash(_priv->rx_tfm_michael);
 	}
-	kzfree(priv);
+	kfree_sensitive(priv);
 }
=20
 static inline u16 RotR1(u16 val)
--- a/net/wireless/lib80211_crypt_wep.c~mm-treewide-rename-kzfree-to-kfree_=
sensitive
+++ a/net/wireless/lib80211_crypt_wep.c
@@ -56,7 +56,7 @@ static void *lib80211_wep_init(int keyid
=20
 static void lib80211_wep_deinit(void *priv)
 {
-	kzfree(priv);
+	kfree_sensitive(priv);
 }
=20
 /* Add WEP IV/key info to a frame that has at least 4 bytes of headroom */
--- a/net/wireless/nl80211.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/wireless/nl80211.c
@@ -9829,7 +9829,7 @@ static int nl80211_join_ibss(struct sk_b
=20
 		if ((ibss.chandef.width !=3D NL80211_CHAN_WIDTH_20_NOHT) &&
 		    no_ht) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
 	}
@@ -9841,7 +9841,7 @@ static int nl80211_join_ibss(struct sk_b
 		int r =3D validate_pae_over_nl80211(rdev, info);
=20
 		if (r < 0) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return r;
 		}
=20
@@ -9854,7 +9854,7 @@ static int nl80211_join_ibss(struct sk_b
 	wdev_lock(dev->ieee80211_ptr);
 	err =3D __cfg80211_join_ibss(rdev, dev, &ibss, connkeys);
 	if (err)
-		kzfree(connkeys);
+		kfree_sensitive(connkeys);
 	else if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
 		dev->ieee80211_ptr->conn_owner_nlportid =3D info->snd_portid;
 	wdev_unlock(dev->ieee80211_ptr);
@@ -10282,7 +10282,7 @@ static int nl80211_connect(struct sk_buf
=20
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY]) {
 		if (!info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
 		memcpy(&connect.ht_capa,
@@ -10300,7 +10300,7 @@ static int nl80211_connect(struct sk_buf
=20
 	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY]) {
 		if (!info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK]) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
 		memcpy(&connect.vht_capa,
@@ -10314,7 +10314,7 @@ static int nl80211_connect(struct sk_buf
 		       (rdev->wiphy.features & NL80211_FEATURE_QUIET)) &&
 		    !wiphy_ext_feature_isset(&rdev->wiphy,
 					     NL80211_EXT_FEATURE_RRM)) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
 		connect.flags |=3D ASSOC_REQ_USE_RRM;
@@ -10322,21 +10322,21 @@ static int nl80211_connect(struct sk_buf
=20
 	connect.pbss =3D nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
 	if (connect.pbss && !rdev->wiphy.bands[NL80211_BAND_60GHZ]) {
-		kzfree(connkeys);
+		kfree_sensitive(connkeys);
 		return -EOPNOTSUPP;
 	}
=20
 	if (info->attrs[NL80211_ATTR_BSS_SELECT]) {
 		/* bss selection makes no sense if bssid is set */
 		if (connect.bssid) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return -EINVAL;
 		}
=20
 		err =3D parse_bss_select(info->attrs[NL80211_ATTR_BSS_SELECT],
 				       wiphy, &connect.bss_select);
 		if (err) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			return err;
 		}
 	}
@@ -10366,13 +10366,13 @@ static int nl80211_connect(struct sk_buf
 		   info->attrs[NL80211_ATTR_FILS_ERP_REALM] ||
 		   info->attrs[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM] ||
 		   info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
-		kzfree(connkeys);
+		kfree_sensitive(connkeys);
 		return -EINVAL;
 	}
=20
 	if (nla_get_flag(info->attrs[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT])) {
 		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
-			kzfree(connkeys);
+			kfree_sensitive(connkeys);
 			GENL_SET_ERR_MSG(info,
 					 "external auth requires connection ownership");
 			return -EINVAL;
@@ -10385,7 +10385,7 @@ static int nl80211_connect(struct sk_buf
 	err =3D cfg80211_connect(rdev, dev, &connect, connkeys,
 			       connect.prev_bssid);
 	if (err)
-		kzfree(connkeys);
+		kfree_sensitive(connkeys);
=20
 	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
 		dev->ieee80211_ptr->conn_owner_nlportid =3D info->snd_portid;
--- a/net/wireless/sme.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/wireless/sme.c
@@ -742,7 +742,7 @@ void __cfg80211_connect_result(struct ne
 	}
=20
 	if (cr->status !=3D WLAN_STATUS_SUCCESS) {
-		kzfree(wdev->connect_keys);
+		kfree_sensitive(wdev->connect_keys);
 		wdev->connect_keys =3D NULL;
 		wdev->ssid_len =3D 0;
 		wdev->conn_owner_nlportid =3D 0;
@@ -1098,7 +1098,7 @@ void __cfg80211_disconnected(struct net_
 	wdev->current_bss =3D NULL;
 	wdev->ssid_len =3D 0;
 	wdev->conn_owner_nlportid =3D 0;
-	kzfree(wdev->connect_keys);
+	kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys =3D NULL;
=20
 	nl80211_send_disconnected(rdev, dev, reason, ie, ie_len, from_ap);
@@ -1281,7 +1281,7 @@ int cfg80211_disconnect(struct cfg80211_
=20
 	ASSERT_WDEV_LOCK(wdev);
=20
-	kzfree(wdev->connect_keys);
+	kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys =3D NULL;
=20
 	wdev->conn_owner_nlportid =3D 0;
--- a/net/wireless/util.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/wireless/util.c
@@ -863,7 +863,7 @@ void cfg80211_upload_connect_keys(struct
 		}
 	}
=20
-	kzfree(wdev->connect_keys);
+	kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys =3D NULL;
 }
=20
--- a/net/wireless/wext-sme.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/net/wireless/wext-sme.c
@@ -57,7 +57,7 @@ int cfg80211_mgd_wext_connect(struct cfg
 	err =3D cfg80211_connect(rdev, wdev->netdev,
 			       &wdev->wext.connect, ck, prev_bssid);
 	if (err)
-		kzfree(ck);
+		kfree_sensitive(ck);
=20
 	return err;
 }
--- a/scripts/coccinelle/free/devm_free.cocci~mm-treewide-rename-kzfree-to-=
kfree_sensitive
+++ a/scripts/coccinelle/free/devm_free.cocci
@@ -89,7 +89,7 @@ position p;
 (
  kfree@p(x)
 |
- kzfree@p(x)
+ kfree_sensitive@p(x)
 |
  krealloc@p(x, ...)
 |
@@ -112,7 +112,7 @@ position p !=3D safe.p;
 (
 * kfree@p(x)
 |
-* kzfree@p(x)
+* kfree_sensitive@p(x)
 |
 * krealloc@p(x, ...)
 |
--- a/scripts/coccinelle/free/ifnullfree.cocci~mm-treewide-rename-kzfree-to=
-kfree_sensitive
+++ a/scripts/coccinelle/free/ifnullfree.cocci
@@ -21,7 +21,7 @@ expression E;
 (
   kfree(E);
 |
-  kzfree(E);
+  kfree_sensitive(E);
 |
   debugfs_remove(E);
 |
@@ -42,7 +42,7 @@ position p;
 @@
=20
 * if (E !=3D NULL)
-*	\(kfree@p\|kzfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|
+*	\(kfree@p\|kfree_sensitive@p\|debugfs_remove@p\|debugfs_remove_recursive=
@p\|
 *         usb_free_urb@p\|kmem_cache_destroy@p\|mempool_destroy@p\|
 *         dma_pool_destroy@p\)(E);
=20
--- a/scripts/coccinelle/free/kfreeaddr.cocci~mm-treewide-rename-kzfree-to-=
kfree_sensitive
+++ a/scripts/coccinelle/free/kfreeaddr.cocci
@@ -20,7 +20,7 @@ position p;
 (
 * kfree@p(&e->f)
 |
-* kzfree@p(&e->f)
+* kfree_sensitive@p(&e->f)
 )
=20
 @script:python depends on org@
--- a/scripts/coccinelle/free/kfree.cocci~mm-treewide-rename-kzfree-to-kfre=
e_sensitive
+++ a/scripts/coccinelle/free/kfree.cocci
@@ -24,7 +24,7 @@ position p1;
 (
 * kfree@p1(E)
 |
-* kzfree@p1(E)
+* kfree_sensitive@p1(E)
 )
=20
 @print expression@
@@ -68,7 +68,7 @@ while (1) { ...
 (
 * kfree@ok(E)
 |
-* kzfree@ok(E)
+* kfree_sensitive@ok(E)
 )
   ... when !=3D break;
       when !=3D goto l;
@@ -86,7 +86,7 @@ position free.p1!=3Dloop.ok,p2!=3D{print.p,s
 (
 * kfree@p1(E,...)
 |
-* kzfree@p1(E,...)
+* kfree_sensitive@p1(E,...)
 )
 ...
 (
--- a/security/apparmor/domain.c~mm-treewide-rename-kzfree-to-kfree_sensiti=
ve
+++ a/security/apparmor/domain.c
@@ -40,8 +40,8 @@ void aa_free_domain_entries(struct aa_do
 			return;
=20
 		for (i =3D 0; i < domain->size; i++)
-			kzfree(domain->table[i]);
-		kzfree(domain->table);
+			kfree_sensitive(domain->table[i]);
+		kfree_sensitive(domain->table);
 		domain->table =3D NULL;
 	}
 }
--- a/security/apparmor/include/file.h~mm-treewide-rename-kzfree-to-kfree_s=
ensitive
+++ a/security/apparmor/include/file.h
@@ -72,7 +72,7 @@ static inline void aa_free_file_ctx(stru
 {
 	if (ctx) {
 		aa_put_label(rcu_access_pointer(ctx->label));
-		kzfree(ctx);
+		kfree_sensitive(ctx);
 	}
 }
=20
--- a/security/apparmor/policy.c~mm-treewide-rename-kzfree-to-kfree_sensiti=
ve
+++ a/security/apparmor/policy.c
@@ -187,9 +187,9 @@ static void aa_free_data(void *ptr, void
 {
 	struct aa_data *data =3D ptr;
=20
-	kzfree(data->data);
-	kzfree(data->key);
-	kzfree(data);
+	kfree_sensitive(data->data);
+	kfree_sensitive(data->key);
+	kfree_sensitive(data);
 }
=20
 /**
@@ -217,19 +217,19 @@ void aa_free_profile(struct aa_profile *
 	aa_put_profile(rcu_access_pointer(profile->parent));
=20
 	aa_put_ns(profile->ns);
-	kzfree(profile->rename);
+	kfree_sensitive(profile->rename);
=20
 	aa_free_file_rules(&profile->file);
 	aa_free_cap_rules(&profile->caps);
 	aa_free_rlimit_rules(&profile->rlimits);
=20
 	for (i =3D 0; i < profile->xattr_count; i++)
-		kzfree(profile->xattrs[i]);
-	kzfree(profile->xattrs);
+		kfree_sensitive(profile->xattrs[i]);
+	kfree_sensitive(profile->xattrs);
 	for (i =3D 0; i < profile->secmark_count; i++)
-		kzfree(profile->secmark[i].label);
-	kzfree(profile->secmark);
-	kzfree(profile->dirname);
+		kfree_sensitive(profile->secmark[i].label);
+	kfree_sensitive(profile->secmark);
+	kfree_sensitive(profile->dirname);
 	aa_put_dfa(profile->xmatch);
 	aa_put_dfa(profile->policy.dfa);
=20
@@ -237,14 +237,14 @@ void aa_free_profile(struct aa_profile *
 		rht =3D profile->data;
 		profile->data =3D NULL;
 		rhashtable_free_and_destroy(rht, aa_free_data, NULL);
-		kzfree(rht);
+		kfree_sensitive(rht);
 	}
=20
-	kzfree(profile->hash);
+	kfree_sensitive(profile->hash);
 	aa_put_loaddata(profile->rawdata);
 	aa_label_destroy(&profile->label);
=20
-	kzfree(profile);
+	kfree_sensitive(profile);
 }
=20
 /**
--- a/security/apparmor/policy_ns.c~mm-treewide-rename-kzfree-to-kfree_sens=
itive
+++ a/security/apparmor/policy_ns.c
@@ -121,9 +121,9 @@ static struct aa_ns *alloc_ns(const char
 	return ns;
=20
 fail_unconfined:
-	kzfree(ns->base.hname);
+	kfree_sensitive(ns->base.hname);
 fail_ns:
-	kzfree(ns);
+	kfree_sensitive(ns);
 	return NULL;
 }
=20
@@ -145,7 +145,7 @@ void aa_free_ns(struct aa_ns *ns)
=20
 	ns->unconfined->ns =3D NULL;
 	aa_free_profile(ns->unconfined);
-	kzfree(ns);
+	kfree_sensitive(ns);
 }
=20
 /**
--- a/security/apparmor/policy_unpack.c~mm-treewide-rename-kzfree-to-kfree_=
sensitive
+++ a/security/apparmor/policy_unpack.c
@@ -163,10 +163,10 @@ static void do_loaddata_free(struct work
 		aa_put_ns(ns);
 	}
=20
-	kzfree(d->hash);
-	kzfree(d->name);
+	kfree_sensitive(d->hash);
+	kfree_sensitive(d->name);
 	kvfree(d->data);
-	kzfree(d);
+	kfree_sensitive(d);
 }
=20
 void aa_loaddata_kref(struct kref *kref)
@@ -894,7 +894,7 @@ static struct aa_profile *unpack_profile
 		while (unpack_strdup(e, &key, NULL)) {
 			data =3D kzalloc(sizeof(*data), GFP_KERNEL);
 			if (!data) {
-				kzfree(key);
+				kfree_sensitive(key);
 				goto fail;
 			}
=20
@@ -902,8 +902,8 @@ static struct aa_profile *unpack_profile
 			data->size =3D unpack_blob(e, &data->data, NULL);
 			data->data =3D kvmemdup(data->data, data->size);
 			if (data->size && !data->data) {
-				kzfree(data->key);
-				kzfree(data);
+				kfree_sensitive(data->key);
+				kfree_sensitive(data);
 				goto fail;
 			}
=20
@@ -1037,7 +1037,7 @@ void aa_load_ent_free(struct aa_load_ent
 		aa_put_profile(ent->old);
 		aa_put_profile(ent->new);
 		kfree(ent->ns_name);
-		kzfree(ent);
+		kfree_sensitive(ent);
 	}
 }
=20
--- a/security/keys/big_key.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/security/keys/big_key.c
@@ -138,7 +138,7 @@ int big_key_preparse(struct key_preparse
 err_fput:
 	fput(file);
 err_enckey:
-	kzfree(enckey);
+	kfree_sensitive(enckey);
 error:
 	memzero_explicit(buf, enclen);
 	kvfree(buf);
@@ -155,7 +155,7 @@ void big_key_free_preparse(struct key_pr
=20
 		path_put(path);
 	}
-	kzfree(prep->payload.data[big_key_data]);
+	kfree_sensitive(prep->payload.data[big_key_data]);
 }
=20
 /*
@@ -187,7 +187,7 @@ void big_key_destroy(struct key *key)
 		path->mnt =3D NULL;
 		path->dentry =3D NULL;
 	}
-	kzfree(key->payload.data[big_key_data]);
+	kfree_sensitive(key->payload.data[big_key_data]);
 	key->payload.data[big_key_data] =3D NULL;
 }
=20
--- a/security/keys/dh.c~mm-treewide-rename-kzfree-to-kfree_sensitive
+++ a/security/keys/dh.c
@@ -58,9 +58,9 @@ error:
=20
 static void dh_free_data(struct dh *dh)
 {
-	kzfree(dh->key);
-	kzfree(dh->p);
-	kzfree(dh->g);
+	kfree_sensitive(dh->key);
+	kfree_sensitive(dh->p);
+	kfree_sensitive(dh->g);
 }
=20
 struct dh_completion {
@@ -126,7 +126,7 @@ static void kdf_dealloc(struct kdf_sdesc
 	if (sdesc->shash.tfm)
 		crypto_free_shash(sdesc->shash.tfm);
=20
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 }
=20
 /*
@@ -220,7 +220,7 @@ static int keyctl_dh_compute_kdf(struct
 		ret =3D -EFAULT;
=20
 err:
-	kzfree(outbuf);
+	kfree_sensitive(outbuf);
 	return ret;
 }
=20
@@ -395,11 +395,11 @@ long __keyctl_dh_compute(struct keyctl_d
 out6:
 	kpp_request_free(req);
 out5:
-	kzfree(outbuf);
+	kfree_sensitive(outbuf);
 out4:
 	crypto_free_kpp(tfm);
 out3:
-	kzfree(secret);
+	kfree_sensitive(secret);
 out2:
 	dh_free_data(&dh_inputs);
 out1:
--- a/security/keys/encrypted-keys/encrypted.c~mm-treewide-rename-kzfree-to=
-kfree_sensitive
+++ a/security/keys/encrypted-keys/encrypted.c
@@ -370,7 +370,7 @@ static int get_derived_key(u8 *derived_k
 	       master_keylen);
 	ret =3D crypto_shash_tfm_digest(hash_tfm, derived_buf, derived_buf_len,
 				      derived_key);
-	kzfree(derived_buf);
+	kfree_sensitive(derived_buf);
 	return ret;
 }
=20
@@ -812,13 +812,13 @@ static int encrypted_instantiate(struct
 	ret =3D encrypted_init(epayload, key->description, format, master_desc,
 			     decrypted_datalen, hex_encoded_iv);
 	if (ret < 0) {
-		kzfree(epayload);
+		kfree_sensitive(epayload);
 		goto out;
 	}
=20
 	rcu_assign_keypointer(key, epayload);
 out:
-	kzfree(datablob);
+	kfree_sensitive(datablob);
 	return ret;
 }
=20
@@ -827,7 +827,7 @@ static void encrypted_rcu_free(struct rc
 	struct encrypted_key_payload *epayload;
=20
 	epayload =3D container_of(rcu, struct encrypted_key_payload, rcu);
-	kzfree(epayload);
+	kfree_sensitive(epayload);
 }
=20
 /*
@@ -885,7 +885,7 @@ static int encrypted_update(struct key *
 	rcu_assign_keypointer(key, new_epayload);
 	call_rcu(&epayload->rcu, encrypted_rcu_free);
 out:
-	kzfree(buf);
+	kfree_sensitive(buf);
 	return ret;
 }
=20
@@ -946,7 +946,7 @@ static long encrypted_read(const struct
 	memzero_explicit(derived_key, sizeof(derived_key));
=20
 	memcpy(buffer, ascii_buf, asciiblob_len);
-	kzfree(ascii_buf);
+	kfree_sensitive(ascii_buf);
=20
 	return asciiblob_len;
 out:
@@ -961,7 +961,7 @@ out:
  */
 static void encrypted_destroy(struct key *key)
 {
-	kzfree(key->payload.data[0]);
+	kfree_sensitive(key->payload.data[0]);
 }
=20
 struct key_type key_type_encrypted =3D {
--- a/security/keys/trusted-keys/trusted_tpm1.c~mm-treewide-rename-kzfree-t=
o-kfree_sensitive
+++ a/security/keys/trusted-keys/trusted_tpm1.c
@@ -68,7 +68,7 @@ static int TSS_sha1(const unsigned char
 	}
=20
 	ret =3D crypto_shash_digest(&sdesc->shash, data, datalen, digest);
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
=20
@@ -112,7 +112,7 @@ static int TSS_rawhmac(unsigned char *di
 	if (!ret)
 		ret =3D crypto_shash_final(&sdesc->shash, digest);
 out:
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
=20
@@ -166,7 +166,7 @@ int TSS_authhmac(unsigned char *digest,
 				  paramdigest, TPM_NONCE_SIZE, h1,
 				  TPM_NONCE_SIZE, h2, 1, &c, 0, 0);
 out:
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(TSS_authhmac);
@@ -251,7 +251,7 @@ int TSS_checkhmac1(unsigned char *buffer
 	if (memcmp(testhmac, authdata, SHA1_DIGEST_SIZE))
 		ret =3D -EINVAL;
 out:
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(TSS_checkhmac1);
@@ -353,7 +353,7 @@ static int TSS_checkhmac2(unsigned char
 	if (memcmp(testhmac2, authdata2, SHA1_DIGEST_SIZE))
 		ret =3D -EINVAL;
 out:
-	kzfree(sdesc);
+	kfree_sensitive(sdesc);
 	return ret;
 }
=20
@@ -563,7 +563,7 @@ static int tpm_seal(struct tpm_buf *tb,
 		*bloblen =3D storedsize;
 	}
 out:
-	kzfree(td);
+	kfree_sensitive(td);
 	return ret;
 }
=20
@@ -1031,12 +1031,12 @@ static int trusted_instantiate(struct ke
 	if (!ret && options->pcrlock)
 		ret =3D pcrlock(options->pcrlock);
 out:
-	kzfree(datablob);
-	kzfree(options);
+	kfree_sensitive(datablob);
+	kfree_sensitive(options);
 	if (!ret)
 		rcu_assign_keypointer(key, payload);
 	else
-		kzfree(payload);
+		kfree_sensitive(payload);
 	return ret;
 }
=20
@@ -1045,7 +1045,7 @@ static void trusted_rcu_free(struct rcu_
 	struct trusted_key_payload *p;
=20
 	p =3D container_of(rcu, struct trusted_key_payload, rcu);
-	kzfree(p);
+	kfree_sensitive(p);
 }
=20
 /*
@@ -1087,13 +1087,13 @@ static int trusted_update(struct key *ke
 	ret =3D datablob_parse(datablob, new_p, new_o);
 	if (ret !=3D Opt_update) {
 		ret =3D -EINVAL;
-		kzfree(new_p);
+		kfree_sensitive(new_p);
 		goto out;
 	}
=20
 	if (!new_o->keyhandle) {
 		ret =3D -EINVAL;
-		kzfree(new_p);
+		kfree_sensitive(new_p);
 		goto out;
 	}
=20
@@ -1107,22 +1107,22 @@ static int trusted_update(struct key *ke
 	ret =3D key_seal(new_p, new_o);
 	if (ret < 0) {
 		pr_info("trusted_key: key_seal failed (%d)\n", ret);
-		kzfree(new_p);
+		kfree_sensitive(new_p);
 		goto out;
 	}
 	if (new_o->pcrlock) {
 		ret =3D pcrlock(new_o->pcrlock);
 		if (ret < 0) {
 			pr_info("trusted_key: pcrlock failed (%d)\n", ret);
-			kzfree(new_p);
+			kfree_sensitive(new_p);
 			goto out;
 		}
 	}
 	rcu_assign_keypointer(key, new_p);
 	call_rcu(&p->rcu, trusted_rcu_free);
 out:
-	kzfree(datablob);
-	kzfree(new_o);
+	kfree_sensitive(datablob);
+	kfree_sensitive(new_o);
 	return ret;
 }
=20
@@ -1154,7 +1154,7 @@ static long trusted_read(const struct ke
  */
 static void trusted_destroy(struct key *key)
 {
-	kzfree(key->payload.data[0]);
+	kfree_sensitive(key->payload.data[0]);
 }
=20
 struct key_type key_type_trusted =3D {
--- a/security/keys/user_defined.c~mm-treewide-rename-kzfree-to-kfree_sensi=
tive
+++ a/security/keys/user_defined.c
@@ -82,7 +82,7 @@ EXPORT_SYMBOL_GPL(user_preparse);
  */
 void user_free_preparse(struct key_preparsed_payload *prep)
 {
-	kzfree(prep->payload.data[0]);
+	kfree_sensitive(prep->payload.data[0]);
 }
 EXPORT_SYMBOL_GPL(user_free_preparse);
=20
@@ -91,7 +91,7 @@ static void user_free_payload_rcu(struct
 	struct user_key_payload *payload;
=20
 	payload =3D container_of(head, struct user_key_payload, rcu);
-	kzfree(payload);
+	kfree_sensitive(payload);
 }
=20
 /*
@@ -147,7 +147,7 @@ void user_destroy(struct key *key)
 {
 	struct user_key_payload *upayload =3D key->payload.data[0];
=20
-	kzfree(upayload);
+	kfree_sensitive(upayload);
 }
=20
 EXPORT_SYMBOL_GPL(user_destroy);
_

Patches currently in -mm which might be from longman@redhat.com are

mm-slab-use-memzero_explicit-in-kzfree.patch
mm-treewide-rename-kzfree-to-kfree_sensitive.patch
